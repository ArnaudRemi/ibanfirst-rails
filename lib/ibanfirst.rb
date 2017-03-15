require 'net/http'
require 'uri'
require 'securerandom'
require 'digest/sha1'
require 'base64'

module Ibanfirst
  # Base model class
  autoload :Base,                 'ibanfirst/base'
  # models classes
  autoload :Auth,                 'ibanfirst/auth'
  autoload :Document,             'ibanfirst/document'
  autoload :ExternalBankAccount,  'ibanfirst/external_bank_account'
  autoload :FinancialMouvement,   'ibanfirst/financial_mouvement'
  autoload :Log,                  'ibanfirst/log'
  autoload :Payment,              'ibanfirst/payment'
  autoload :Trade,                'ibanfirst/trade'
  autoload :Wallet,               'ibanfirst/wallet'

  class Configuration
    attr_accessor :api_path, :password, :username, :email_contact

    def initialize
      # TODO add all key value from ENV
      # or put it throught initialiazer
      @email_contact = 'contact@example.com'
    end
  end

  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield self.config
    end

    # from mangopay: (method, url, params={}, filters={}, headers_or_idempotency_key = nil, before_request_proc = nil)
    def request(method, url, params={}, filters={}, headers_opt = nil)
      uri = api_uri(url)
      uri.query = URI.encode_www_form(filters) unless filters.empty?

      nonce = SecureRandom.hex(14)
      nonce64 = Base64.encode64(nonce)
      datetime = Time.now.iso8601
      digest = Base64.encode64( Digest::SHA1.hexdigest( nonce + datetime + config.password ) )

      headers = {
        'Content-Type' => 'application/json',
        'X-WSSE' => "UsernameToken Username=\"#{config.username}\", PasswordDigest=\"#{digest}\", Nonce=\"#{nonce64}\", Created=\"#{datetime}\"" 
      }

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
        req.body = JSON.dump(params)
        do_request(http, req, uri)
      end

      # decode json data
      data = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)

      data
    end
  end


  # test
  def self.hi
    puts "Hello world!"
  end
end