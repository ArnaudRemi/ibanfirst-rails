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
  autoload :FinancialMovement,    'ibanfirst/financial_movement'
  autoload :Log,                  'ibanfirst/log'
  autoload :Payment,              'ibanfirst/payment'
  autoload :Trade,                'ibanfirst/trade'
  autoload :Wallet,               'ibanfirst/wallet'

  # Config class
  class Configuration
    attr_accessor :api_path, :password, :username, :email_contact, :debug

    def initialize
      # TODO add all key value from ENV
      # or put it throught initialiazer
      @email_contact = 'contact@example.com'
      debug = false
    end
  end

  # Errors
  class Error < StandardError
  end

  class ResponseError < Error
    attr_reader :request_url, :code, :type

    def initialize(request_url, code, type='Unknown Type')
      @request_url, @code, @type = request_url, code, type

      super(type)
    end
  end

  class RequestError < Error
  end

  # Class method
  class << self
    attr_accessor :config

    def configure
      self.config ||= Configuration.new
      yield self.config
    end

    def request(method, url, params={}, filters={}, headers_opt = nil)
      Rails.logger.debug "#{method}  #{config.api_path}/#{url}"
      Rails.logger.debug "params: #{params}"
      Rails.logger.debug "filters: #{filters}"
      uri = URI("#{config.api_path}/#{url}")
      uri.query = URI.encode_www_form(filters) unless filters.empty?

      nonce = SecureRandom.hex(16)
      nonce64 = Base64.strict_encode64(nonce)
      datetime = Time.now.utc.iso8601
      Rails.logger.debug "nonce #{nonce}"
      Rails.logger.debug "nonce64 #{nonce64}"
      Rails.logger.debug "datetime #{datetime}"

      digest = Base64.strict_encode64( Digest::SHA1.digest( nonce + datetime + config.password ) )
      Rails.logger.debug "digest #{digest}"

      headers = {
        'Content-Type' => 'application/json',
        'X-WSSE' => "UsernameToken Username=\"#{config.username}\", PasswordDigest=\"#{digest}\", Nonce=\"#{nonce64}\", Created=\"#{datetime}\"" 
      }

      Rails.logger.debug "headers: #{headers}"
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, headers)
        req.body = JSON.dump(params)
        http.request(req)
      end

      # decode json data
      data = res.body.to_s.empty? ? {} : JSON.load(res.body.to_s)

      Rails.logger.debug "response data #{data}" if data['Error'] || data['errorCode'] || config.debug
      raise ResponseError.new(uri, data['Error']['errorCode'], data['Error']['errorType']) if data['Error']
      raise ResponseError.new(uri, data['errorCode'], data['errorType']) if data['errorCode']

      data
    end
  end
end