class WebhookWorker

  include Sidekiq::Worker
  sidekiq_options retry: 10, dead: false

  end

  def perform(webhook_event_id)
    webhook_event = WebhookEvent.find_by(id: webhook_event_id)
    return if
      webhook_event.nil?

    webhook_endpoint = webhook_event.webhook_endpoint
    return if
      webhook_endpoint.nil?

    response = HTTP.timeout(30)
                   .headers(
                     'User-Agent' => 'rails_webhook_system/1.0',
                     'Content-Type' => 'application/json',
                     'Authorization' =>  'Bearer <token>'
                     )
                   .post(
                     webhook_endpoint.url,
                     body: {
                       data: {
                          customer_name: webhook_event.customer_name, customer_phone:webhook_event.customer_number, site_id:webhook_event.store_number
                       }
                     }.to_json
                   )

    webhook_event.update(response: {
      headers: response.headers.to_h,
      code: response.code.to_i,
      body: response.body.to_s,
    })

    if response.status.success?
      logger.info "[webhook_worker] Delivered webhook event: event=#{webhook_event.id} endpoint=#{webhook_endpoint.id} url=#{webhook_endpoint.url}"
      return
    end

    if response.status.error?
      logger.info "[webhook_worker] Did not deliver webhook event: event=#{webhook_event.id} endpoint=#{webhook_endpoint.id} url=#{webhook_endpoint.url}"
      return
    end

    rescue JSON::ParserError => e
             render json: {:status => 400, :error => "Invalid payload"}
  end

  private

  def logger
    Sidekiq.logger
  end

  class FailedRequestError < StandardError; end




