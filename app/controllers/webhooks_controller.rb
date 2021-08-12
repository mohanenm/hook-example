SITES = {}
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate

  def receive

    site_id = SITES[params[:result][:store_number]]

    @customer = WebhookEvent.create!(:webhook_endpoint_id => 1, :store_number => site_id, :customer_number => params.dig(:result, :customer_number), :customer_name => params.dig(:result, :customer_name))

    if @customer.save
      render json: {:status => 200}

      # initialize a webhook order that takes in the last created hook.
      # Can someone check me on this? I want to make sure it is actually the right one
      WebhookWorker.new.perform(WebhookEvent.last)

      puts "waiting for new job"

    end

    rescue JSON::ParserError => e
      render json: {:status => 400, :error => "Invalid payload"}, status: :bad_request
  end

private

  def authenticate
    unless token == params[:token]
      render json: {:status => 401, :error => "Unauthorized"}, status: :unauthorized
    end
  end

  def token
    @token ||= ENV['TOKEN']
  end

end
