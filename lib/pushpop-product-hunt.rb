require 'pushpop'
require 'pushpop-product-hunt/client'
require 'date'

module Pushpop
  module ProductHunt 
    class Step < Pushpop::Step

      PLUGIN_NAME = 'product_hunt'

      Pushpop::Job.register_plugin(PLUGIN_NAME, self)

      ## SETUP FUNCTIONS ##
      
      def run(last_response=nil, step_responses=nil)
        client.reset()

        ret = self.configure(last_response, step_responses)

        resp = client.get()

        if resp
          resp
        else
          ret
        end
      end

      def configure(last_response=nil, step_responses=nil)
        self.instance_exec(last_response, step_responses, &block)
      end

      def client
        if @client
          @client
        else
          if ENV['PRODUCT_HUNT_TOKEN'].nil? || ENV['PRODUCT_HUNT_TOKEN'].empty?
            raise 'You have to set the PRODUCT_HUNT_TOKEN'
          else
            @client = Pushpop::ProductHunt::Client.new(ENV['PRODUCT_HUNT_TOKEN'])
          end
        end
      end

      ## QUERYING FUNCTIONS ##
      
      def day(date = nil)
        client.type('posts')

        if date.is_a? String
          # Parse the date, and then reoutput it to get a consistent format
          client.option('day', Date.parse(date).to_s)
        elsif date.is_a? Date
          client.option('day', date.to_s)
        elsif date.is_a? Numeric
          client.option('days_ago', date)
        elsif !date.nil?
          raise 'Unknown date format'
        end
      end

      def posts(url = nil)
        client.identifier('all')
        client.type('posts')

        unless url.nil?
          client.option('search[url]' => url)
        end 
      end

      def post(id)
        client.post(id)
      end

      def users
        client.type('users')
      end

      def user(id)
        client.user(id)
      end

      def collections
        client.type('collections')
      end

      def featured_collections
        collections
        client.option('search[featured]' => true)
      end

      # Options Functions
      
      def per_page(count)

      end

      def older_than(max)

      end
      
      def newer_then(min)

      end

      def sort(field, direction = 'asc')
        
      end
    end
  end
end
