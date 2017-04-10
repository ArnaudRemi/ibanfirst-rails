module Ibanfirst
  class ExternalBankAccount < Base
  	class << self
  		def base_name
  			'account'
  		end

  		def base_url
  			'externalBankAccounts'
  		end
  	end
  end
end