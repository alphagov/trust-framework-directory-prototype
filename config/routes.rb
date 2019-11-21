Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ssa#index'

  post '/organisation/:organisation_type', to: 'organisation#register'

  get '/organisation/:organisation_type', to: 'organisation#list_orgs'

  post '/client-csr', to: 'certificate#generate'

  post '/token', to: 'token#make_token'

  get '/organisation/:organisation_type/:organisation_id/software-statement', to: 'ssa#generate'

  get '/organisation/:organisation_type/:organisation_id/certificate/:certificate_type', to: 'organisation#get_certificate'

  get '/organisation/:organisation_type/:organisation_id/software-statement/:ssa_id/certificates', to: 'ssa#get_certificates'

  get '/organisation/:organisation_type/:organisation_id/software-statement/:ssa_id/software-statement-assertion', to: 'ssa#get_ssa'

  get '/authorization-servers', to: 'authorization_servers#return_uris'

  post '/onboard', to: 'onboard#confirm'

  get '/revoked/organisation/:name', to: 'revoked#revoked_organisation'

  get '/revoked/software/:ssa_id', to: 'revoked#revoked_software'

  get '/organisation/:organisation_type/:organisation_id/certificates', to: 'organisation#certificates'

  get '/directory/:ssa_id/key', to: 'directory#ssa_signing_public_key'

  get '/directory/root-ca', to: 'directory#root_ca'
end
