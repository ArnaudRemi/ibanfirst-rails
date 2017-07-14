module Ibanfirst
  class Document < Base

  	class << self
  		def rib
  			Ibanfirst.request('GET', "#{base_url}/RIB")[base_name.to_s]
  		end
  	end
  end
end
