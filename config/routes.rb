Rails.application.routes.draw do
root 'welcome#index'
  post '/hooks' => 'webhooks#receive'
  post '/api/v1/orders', to: proc { [204, {}, []] }
end
