module Ibanfirst
  class Wallet < Base

  	class << self
  		# date need to be String formated like 'YYYY-MM-DD'
	  	def balance_for_date(id, date)
	  		raise RequestError.new('The id is mandatory for this use') unless id
	  		raise RequestError.new('The date is mandatory for this use') unless date
	  		# TODO: validate date format
        Ibanfirst.request('GET', "#{build_url(id.to_s)}/balance/#{date}")[base_name.to_s]
	  	end

	  	def generate_iban(branch, account_number)
	  		raise RequestError.new('The branch is mandatory for this use') unless branch
	  		raise RequestError.new('The account_number is mandatory for this use') unless account_number
	  		Ibanfirst.request('GET', "#{base_url}/generateIBAN/#{branch}/#{account_number}")[base_name.to_s]
	  	end
	  end
  end
end
