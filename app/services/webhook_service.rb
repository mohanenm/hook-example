class WebhookService
  def self.call(store_number:, customer_name:, customer_number:)
    new(store_number:store_number, customer_name:customer_name, customer_number:customer_number).call
  end

  def call
      webhook_event = WebhookEvent.create!(
        webhook_endpoint_id: 1,
        store_number: store_number,
        customer_name: customer_name,
        customer_number: customer_number
        )
      WebhookWorker.perform_async(webhook_event.id)
    end

  private

  attr_reader :store_number, :customer_name, :customer_number

  def initialize(store_number:, customer_name:, customer_number:)
    @customer_name = customer_name
    @store_number = store_number
    @customer_number = customer_number
  end
end
