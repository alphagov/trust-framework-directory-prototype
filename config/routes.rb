Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ssa#index'

  get '/generate/tpp/:name/ssa/:ssa_id', to: 'ssa#generate'

  post '/client_csr', to: 'csr#register'

  get '/signed_certificate/:client_id', to: 'csr#signed_certificate'

  post '/token', to: 'token#make_token'

  get '/authorization_servers', to: 'authorization_servers#return_uris'

  post '/onboard', to: 'onboard#confirm'

  get '/jwk-uri/organisation/:name', to: 'jwk_uri#get_org_public_key'

  get '/jwk-uri/software/:ssa_id', to: 'jwk_uri#get_software_public_key'
end
