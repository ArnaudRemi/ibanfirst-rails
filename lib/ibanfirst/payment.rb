module Ibanfirst
  class Payment < Base

  	class << self
	  	def confirm(id)
	  		raise .new('The id is mandatory for this use') unless id
	  		url = build_url(id.to_s) + '/confirm/'
	      Ibanfirst.request('PUT', url)
	  	end

	  	def list(filters={})
	  		# if no status, list all
	  		# raise RequestError.new('Payment list need a status') unless filters.key?('status')
	  		status = filters.delete('status') || 'all'
	  		url = "#{build_url}_#{status}/"
	  		Ibanfirst.request('GET', url, nil, filters)
	  	end
	  end
  end
end
