module Ibanfirst
  class Base

    class << self
      def base_url
        @base_url ||= begin
          # do not use base_name because some response keys are not (yet?) the same as base_url
          model_chain = self.name.split('::')
          model_chain.last.downcase.pluralize
        end
      end

      def base_name
        @base_name ||= begin
          model_chain = self.name.split('::')
          model_chain.last.downcase
        end
      end

      def build_url(id = nil)
        if self == Base
          raise RequestError.new('Base is an abstract class. Do not use it directly.')
        end
        if id
          "#{base_url}/-#{CGI.escape(id)}"
        else
          "#{base_url}/"
        end
      end

      #def request(method, url, params={}, filters={}, headers_opt = nil)
      def create(params={})
        Ibanfirst.request('POST', build_url, params)[base_name.to_s]
      end

      def list(filters={})
        Ibanfirst.request('GET', build_url, nil, filters)[base_name.pluralize.to_s]
      end

      def update(id, params={})
        raise RequestError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('PUT', build_url(id.to_s), params)[base_name.to_s]
      end

      def retreive(id)
        raise RequestError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('GET', build_url(id.to_s))[base_name.to_s]
      end

      def delete(id)
        raise RequestError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('DELETE', build_url(id.to_s))['process']
      end
    end
  end
end