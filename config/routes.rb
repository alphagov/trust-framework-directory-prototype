Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ssa#index'

  get '/generate/tpp/:name/ssa/:ssa_id', to: 'ssa#generate'

  post '/client_csr', to: 'csr#register'

  post '/token', to: 'token#make_token'

  get '/endpoint', to: 'endpoint#return_uris'

  post '/onboard', to: 'onboard#confirm'

  get '/jwk_uri/:key_id', to: 'jwk_uri#get_key'
end
