class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :auth

  def receive

    if WebhookService.call(store_number: params.dig(:payload, :store_number), customer_name:params.dig(:payload, :customer_name) , customer_number:params.dig(:payload, :customer_number))
      render json: {:status => 200}
    else
      render json: {:status => 404, :error => "generic error message that makes people mad"}, status: :bad_request
    end

  rescue JSON::ParserError => e
    render json: {:status => 400, :error => "Invalid payload"}, status: :bad_request

  rescue Exception => e
    render json: {:status => 500, :error => e}, status: :internal_server_error
  end

  private

  def auth
    unless ActiveSupport::SecurityUtils.secure_compare(token, params.dig(:payload, :token))
      render json: {:status => 401, :error => "Unauthorized"}, status: :unauthorized
    end
  end

  def token
    @token ||= 'your-secret'
  end
end





