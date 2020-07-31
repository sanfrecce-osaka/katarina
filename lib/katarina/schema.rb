# frozen_string_literal: true

require 'active_support/all'

module Katarina
  class Schema
    attr_reader :controller

    def initialize(path, controller, action, http_method, response_code, schema)
      @path = path
      @controller = controller
      @action = action
      @http_method = http_method
      @response_code = response_code
      @schema = schema
    end

    def types(schema = @schema)
      case schema
      in { type: 'object', properties: } then build_object(properties)
      in { type: 'array', items: }       then [types(items)]
      in { type: type }                  then type
      end
    end

    def name
      [
        prefix,
        *Katarina::Path.include_paths(@controller.split('/')),
        action,
        response_code.to_s
      ].map(&:camelize).join
    end

    private

    attr_reader :path, :action, :http_method, :response_code

    def prefix
      Katarina.config.prefix ? 'T' : ''
    end

    def build_object(properties)
      properties.keys.each_with_object({}) { _2[_1] = property_type(properties[_1]) }
    end

    def property_type(property)
      case property
      in { type: 'object' | 'array' } then types(property)
      in { type: }                    then type
      end
    end
  end
end
