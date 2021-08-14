class WebhookEvent < ApplicationRecord
  belongs_to :webhook_endpoint, inverse_of: :webhook_events
  validates :webhook_endpoint_id, presence: true
  validates :customer_name, presence: true
  validates :store_number, presence: true
  validates :customer_number, presence: true
end
