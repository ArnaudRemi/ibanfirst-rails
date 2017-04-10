module Ibanfirst
  class Wallet < Base

  	class << self
  		# date need to be String formated like 'YYYY-MM-DD'
	  	def balance_for_date(id, date)
	  		raise RequestError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('GET', "#{build_url(id.to_s)}/balance/#{date}")[base_name.to_s]
	  	end
	  end

  end
end
