
class EndpointController < ApplicationController

  def return_uris

    render json: { 'Resources':
      [
        { 'AuthorisationServers': {
            'CustomerFriendlyName': 'something',
            'BaseApiDNSUri': 'http://localhost:3000/onboard'
          }
        }
      ]
    }

  end

end
