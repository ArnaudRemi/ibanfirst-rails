module Ibanfirst
  class Base

    class << self
      def base_url
        @base_url ||= begin
          model_chain = self.class.name.split('::')
          "/#{model_chain.last.camelize(:lower).pluralize}/"
        end
      end

      def build_url(id = nil)
        if self == Base
          raise NotImplementedError.new('Resource is an abstract class. Do not use it directly.')
        end
        if id
          "#{Ibanfirst.config.api_path}/#{base_url}/-#{CGI.escape(id)}"
        else
          "#{Ibanfirst.config.api_path}/#{base_url}"
        end
      end


      #def request(method, url, params={}, filters={}, headers_opt = nil)
      def create(params={})
        Ibanfirst.request('POST', build_url, params)
      end

      def list(filters={})
        Ibanfirst.request('GET', build_url, nil, filters)
      end

      def update(id, params={})
        raise NotImplementedError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('PUT', build_url(id), params)
      end

      def retreive(id)
        raise NotImplementedError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('GET', build_url(id))
      end

      def delete(id)
        raise NotImplementedError.new('The id is mandatory for this use') unless id
        Ibanfirst.request('DELETE', build_url(id))
      end
    end
  end
end