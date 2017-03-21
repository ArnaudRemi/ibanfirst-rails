# ibanfirst-rails

Gem for the Ibanfirst API [WIP]

# Usage

Before everthing else, create an ibanfirst account.

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
Resource.create(params)
Resource.list(filters) # filters can be nil
Resouce.update(id, params)
Resouce.retreive(id)
Resouce.delete(id)
```

Every feedback is welcome.

