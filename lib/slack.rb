require 'faraday'
require 'json'

module Slack
  class SlackApiHelper
    BASE = 'https://slack.com/api/'

    class << self
      def errors(response)
        error = { errors: { status: response["status"], message: response["message"] } }
        response.merge(error)
      end

      def get(url, query = {})
        response, status = get_json(url, query)
        status == 200 ? response : errors(response)
      end

      def post(url, data = '')
        response, status = post_json(url, data)
        status == 200 ? response : errors(response)
      end

      def get_json(root_path, query = {})
        query_string = query.map{|k,v| "#{k}=#{v}"}.join("&")
        path = query.empty?? root_path : "#{root_path}?#{query_string}"
        response = api.get(path)
        [JSON.parse(response.body), response.status]
      end

      def post_json(path, data = '')
        response = api.post(path, data)
        [JSON.parse(response.body), response.status]
      end

      def api
        Faraday.new(url: BASE) do |faraday|
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Authorization'] = "Bearer #{ENV['SLACK_API_TOKEN']}"
        end
      end
    end
  end
end
