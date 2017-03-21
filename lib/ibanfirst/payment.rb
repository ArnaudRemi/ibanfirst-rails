module Ibanfirst
  class Payment < Base

  	def confirm(id)
  		raise NotImplementedError.new('The id is mandatory for this use') unless id
  		url = build_url(id.to_s) + 'confirm/'
      Ibanfirst.request('PUT', url)
  	end

  end
end
