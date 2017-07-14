module Ibanfirst
  class Auth < Base
    
    class << self
	  	def base_url
				'APIHelpers/Auth/'
			end

			def with_token(token)
				raise RequestError.new('The token is mandatory for this use') unless token
				Ibanfirst.request('GET', "#{base_url}/WithToken/#{token}")[base_name.to_s]
			end

			def invalidate(token)
				raise RequestError.new('The token is mandatory for this use') unless token
				Ibanfirst.request('GET', "#{base_url}/Invalidate/Token/#{token}")[base_name.to_s]
			end
    end
  end
end