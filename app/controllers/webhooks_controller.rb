SITES = {}
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # need to add authentication

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

end
