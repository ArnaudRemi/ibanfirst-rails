# ibanfirst-rails

Gem for the Ibanfirst API [WIP]

# Usage

Before everthing else, create an ibanfirst account.

Add the Gem to your Gemfile
```
gem "ibanfirst-rails", :git => 'git@github.com:ArnaudRemi/ibanfirst-rails.git'
```

Create an initializer for ibanfirst. You should put it into `config/initializers/ibanfirst.rb'.
```
require 'ibanfirst'

Ibanfirst.configure do |config|
  config.username = 'your_username'
  config.password = 'your_password'
  config.api_path = 'the-api-path.ibanfirst.com'
  config.email_contact = 'your_contact_email@your.domain'
end
```

Then you will be able to use the differents ibanfirst resources:
- Auth
- Document
- ExternalBankAccount
- FinancialMouvement
- Log
- Payment
- Trade
- Wallet

on each one you can use the CRUD funtions: create, list, update, retreive and delete
```
Ibanfirst::Resource.create(params)
Ibanfirst::Resource.list(filters)
Ibanfirst::Resource.update(id, params)
Ibanfirst::Resource.retreive(id)
Ibanfirst::Resource.delete(id)
```

(For the moment) The result is the Hash or Array stored into the response.
(In a near futur, we will use resource instance with proper functions, ect)

By exemple:
```
Ibanfirst::Wallet.list
=> [
  {"id"=>"XXXXXXX", "tag"=>"E-compte EUR", "currency"=>"EUR", "bookingAmount"=>{"value"=>"4037.64", "currency"=>"EUR"}, "valueAmount"=>{"value"=>"4037.64", "currency"=>"EUR"}, "dateLastFinancialMovement"=>"2017-02-03 15:15:14"}, 
  {"id"=>"XXXXXXY", "tag"=>"E-compte USD", "currency"=>"USD", "bookingAmount"=>{"value"=>"2606.29", "currency"=>"USD"}, "valueAmount"=>{"value"=>"2606.29", "currency"=>"USD"}, "dateLastFinancialMovement"=>"2017-02-03 15:23:30"}, 
  {"id"=>"XXXXXXZ", "tag"=>"E-compte HKD", "currency"=>"HKD", "bookingAmount"=>{"value"=>"0.00", "currency"=>"HKD"}, "valueAmount"=>{"value"=>"0.00", "currency"=>"HKD"}, "dateLastFinancialMovement"=>nil}
]
```

Some resources have specific functions.
Let list them.

```
# Wallet
Ibanfirst::Wallet.balance(id, date)                     
Ibanfirst::Wallet.generateIBAN(branch, accountNumber)   


# Payment
Ibanfirst::Payment.confirm(id)
Ibanfirst::Payment.list()                               # status specified into filters: {status: 'all'}


# Trades
Ibanfirst::Trades.rates(['EUR', 'USD'])
Ibanfirst::Trades.quotes(params)
Ibanfirst::Trades.list()                                # status specified into filters: {status: 'all'}

# Document
Ibanfirst::Document.retreiveRIB(rib)

# Auth
Ibanfirst::Auth.withtoken(token)
Ibanfirst::Auth.invalidate(token)
```



Every feedback is welcome.

