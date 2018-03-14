module Analytics
  module Helpers
    module AuthenticationDSL
      #
      # Defines before filters for the specified paths that authenticate and
      # organization from the +org_api_key+ and +org_secret_key+ in the request
      # parameters and leaves it in an instance variable.
      #
      def authenticated(*paths)
        paths.each do |path|
          before vroute(path) do
            content_type :json

            @org = authenticate!(params[:org_api_key], params[:org_secret_key])
          end
        end
      end
    end

    module Authentication
      #
      # Authenticates an organization from its api keys
      #
      def authenticate!(api_key, secret_key)
        unauthorized('Organization API key not provided') unless api_key

        org = Organization.find_by(org_api_key: api_key)
        unauthorized('Unknown organization API key') unless org

        unauthorized('Organization secret key not provided') unless secret_key

        verified = org.verify_secret(secret_key)
        unauthorized('Invalid organization API credentials') unless verified

        org
      end

      private

      #
      # Halts the request with status 401 unauthorized and a custom message
      #
      def unauthorized(msg)
        halt(401, json(error: msg))
      end
    end
  end
end
