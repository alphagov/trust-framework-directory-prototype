class AuthorizationServersController < ApplicationController
  def return_uris
    render json: { 'Resources':
      [
        { 'AuthorisationServers': [
            {
              'CustomerFriendlyName': friendly_name,
              'BaseApiDNSUri': File.join(server_uri, 'onboard')
            }
          ]
        }
      ]
    }
  end

private

  def friendly_name
    return 'Frodo Baggins' unless ENV['VCAP_APPLICATION']

    JSON.parse(ENV['VCAP_APPLICATION'])['application_name']
  end

  def server_uri
    return request.base_url unless ENV['VCAP_APPLICATION']

    "https://#{JSON.parse(ENV['VCAP_APPLICATION'])['application_uris'].first}"
  end

end
