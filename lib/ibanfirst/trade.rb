module Ibanfirst
  class Trade < Base
  	class << self
  		def list(filters={})
	  		# if no status, list all
  			status = filters.delete('status') || 'all'
	  		url = "#{build_url}_#{status}/"
	  		Ibanfirst.request('GET', url, nil, filters)[base_name.pluralize.to_s]
      end
  	end
  end
end