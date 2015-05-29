require 'httparty'
require 'json'

module Pushpop
  module ProductHunt
    class Client
      include HTTParty

      API_VERSION = 'v1'
      base_uri 'https://api.producthunt.com'

      USER_SCOPABLE_ENDPOINTS = [
        'posts',
        'collections'
      ]

      POST_SCOPABLE_ENDPOINTS = [
        'users',
        'collections'
      ]

      attr_accessor :_user
      attr_accessor :_post
      
      def initialize(token)
        @api_token = token
      end

      def get
        url = construct_url

        if url
          self.class.headers({
            'Accept' => 'application/json',
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{@api_token}"
          })

          response = self.class.get(construct_url)

          if response.code == 200
            JSON.parse(response.body)
          else
            raise "Something went wrong with the Product Hunt request, returned status code #{response.code}"
          end
        else
          false
        end
      end

      def reset
        self._user = nil
        self._post = nil
      end

      def construct_url
        return false unless @type

        url = "/#{API_VERSION}/#{@type}"    

        if @identifier
          url = "#{url}/#{@identifier}"

          if @subtype
            url = "#{url}/#{@subtype}"
          end 
        end


        url
      end

      def type(type)
        @type = type
        set_contextual_identifier
      end

      def subtype(type)
        @subtype = type
      end

      def identifier(id)
        @identifier = id
      end

      def user(id)
        self._user = id
        type('users')
        identifier(id)
      end

      def post(id)
        self._post = id
        type('posts')
        identifier(id)
      end

      # If the user sets a specific post ID or user ID prior to calling
      # one of the list functions like #collections, we should scope
      # that call to only return items that are related
      def set_contextual_identifier
        # Let's prioritize user identifiers over posts identifiers
        if self._user && USER_SCOPABLE_ENDPOINTS.include?(@type)
          @subtype = @type
          @type = 'users'
          @identifier = self._user

          true
        elsif self._post && POST_SCOPABLE_ENDPOINTS.include?(@type)
          @subtype = @type
          @type = 'posts'
          @identifier = self._post

          true
        else
          false
        end
      end
      
    end
  end
end
