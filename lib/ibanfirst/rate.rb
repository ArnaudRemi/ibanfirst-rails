module Ibanfirst
  class Rate < Base
  	class << self
  		def list(instrument, filters={})
  			raise RequestError.new('The instruments is mandatory for this use') unless instruments
        Ibanfirst.request('GET', build_url, nil, filters)[base_name.pluralize.to_s]
      end
  	end
  end
end