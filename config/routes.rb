Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ssa#index'

  post '/client-csr', to: 'csr#register'

  get '/certificate/:client_id', to: 'csr#mtls_and_signing_certificate'

  post '/token', to: 'token#make_token'

  get '/generate/organisation/:name/ssa/:ssa_id', to: 'ssa#generate'

  get '/authorization-servers', to: 'authorization_servers#return_uris'

  post '/onboard', to: 'onboard#confirm'

  get '/jwk-uri/organisation/:name', to: 'jwk_uri#get_org_public_key'

  get '/jwk-uri/software/:ssa_id', to: 'jwk_uri#get_software_public_key'

  get '/revoked/organisation/:name', to: 'revoked#revoked_organisation'

  get '/revoked/software/:ssa_id', to: 'revoked#revoked_software'
end
