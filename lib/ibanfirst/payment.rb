module Ibanfirst
  class Payment < Base

  	class << self
	  	def confirm(id)
	  		raise .new('The id is mandatory for this use') unless id
	  		url = build_url(id.to_s) + '/confirm'
	      Ibanfirst.request('PUT', url)[base_name.to_s]
	  	end

	  	def list(filters={})
	  		# if no status, list all
	  		# raise RequestError.new('Payment list need a status') unless filters.key?('status')
	  		status = filters.delete('status') || 'all'
	  		url = "#{build_url}_#{status}/"
	  		Ibanfirst.request('GET', url, nil, filters)[base_name.pluralize.to_s]
	  	end

	  	def proof_of_transaction(id, proof)
	  		# proof is the JSON hash with the base64 file into file key 
	  		raise .new('The id is mandatory for this use') unless id
	  		raise .new('The proof is mandatory for this use') unless proof
	  		url = build_url(id.to_s) + '/proofOfTransaction'
	      Ibanfirst.request('PUT', url, proof)[base_name.to_s]
	  	end
	  end
  end
end
