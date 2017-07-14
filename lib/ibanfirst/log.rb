module Ibanfirst
  class Log < Base
  	class << self
  		def retreive(nonce)
        raise RequestError.new('The nonce is mandatory for this use') unless nonce
        Ibanfirst.request('GET', build_url(nonce.to_s))[base_name.to_s]
      end
    end
  end
end