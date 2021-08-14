Rails.application.routes.draw do
root 'welcome#index'
  post '/hooks' => 'webhooks#receive'
  get '/hooks' => 'get#dont_do_that'
  # put '/hooks' => 'put#dont_do'
end
