Rails.application.routes.draw do
  ## Misc directory specific endpoints.
  root 'ssa#index'

  get '/admin', to: 'admin#index'

  get '/admin/delete/organisation/:org_id', to: 'admin#delete_selected'

  get '/admin/delete/:organisation_type', to: 'admin#delete_by_org_type', as: :delete_organisations

  get '/directory/:ssa_id/key', to: 'directory#ssa_signing_public_key'

  get '/directory/root-ca', to: 'directory#root_ca'

  # This is terrible. Never do this
  get '/keys/:organisation_id', to: 'keys#org_private_keys'


  ## Specifically for the onboarding app only
  post '/organisation/:organisation_type', to: 'organisation#register'

  post '/client-csr', to: 'certificate#generate'

  post '/token', to: 'token#make_token'

  get '/authorization-servers', to: 'authorization_servers#return_uris'

  post '/onboard', to: 'onboard#confirm' # Probably not necessary anymore


  ## Some of the open banking directory API endpoints. Ish
  ## https://github.com/OpenBankingUK/directory-api-specs/blob/master/directory-api-swagger.yaml
  get '/organisation/:organisation_type/:organisation_id/software-statement', to: 'ssa#generate'

  get '/organisation/:organisation_type/:organisation_id/certificate/:certificate_type', to: 'organisation#get_certificate'

  get '/organisation/:organisation_type/:organisation_id/software-statement/:ssa_id/certificates', to: 'ssa#get_certificates'

  get '/organisation/:organisation_type/:organisation_id/software-statement/:ssa_id/software-statement-assertion', to: 'ssa#get_ssa'

  get '/revoked/organisation/:name', to: 'revoked#revoked_organisation'

  get '/revoked/software/:ssa_id', to: 'revoked#revoked_software'

  get '/organisation/:organisation_type/:organisation_id/certificates', to: 'organisation#certificates'

  get '/organisation/:organisation_type/:scheme', to: 'organisation#list_orgs'
end
