# frozen_string_literal: true

require 'httparty'

module PYR
  # The object returned by a request call to the API.
  class Response
    attr_reader :body, :url, :code, :message, :headers, :objects, :controller

    def initialize(base_url: nil, resource: nil, response_object: nil)
      if base_url && resource
        @controller = resource.controller
        url = "#{base_url}#{resource}"
      elsif response_object
        @controller = response_object.controller
        url = response_object.self
      end

      payload     = HTTParty.get url
      @url        = url
      @body       = payload.parsed_response
      @code       = payload.code
      @message    = payload.message
      @headers    = payload.headers
      parse_objects
    end

    def parse_objects
      parser = Parser.new
      @objects = parser.parse(body, controller)
    end
  end
end