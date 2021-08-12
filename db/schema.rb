ActiveRecord::Schema.define(version: 2021_08_11_152011) do
  enable_extension "plpgsql"

  create_table "webhook_endpoints", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "subscriptions", default: ["*"]
  end

  create_table "webhook_events", force: :cascade do |t|
    t.integer "webhook_endpoint_id", null: false
    t.string "customer_name"
    t.string "customer_number"
    t.integer "store_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "response", default: {}
    t.index ["webhook_endpoint_id"], name: "index_webhook_events_on_webhook_endpoint_id"
  end

end
