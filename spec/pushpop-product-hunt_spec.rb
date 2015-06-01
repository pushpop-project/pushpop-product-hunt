require 'spec_helper'
require 'date'
require 'webmock/rspec'
require 'json'

ENV['PRODUCT_HUNT_TOKEN'] = '12345'

describe Pushpop::ProductHunt::Step do

  before(:each) do
    stub_request(:get, /.*api\.producthunt\.com.*/).
      to_return(:body => JSON.generate({:success => true}))
  end

  describe 'internal functions' do
    it 'has a ProductHunt::Client' do
      step = Pushpop::ProductHunt::Step.new

      expect(step.client).to be_a(Pushpop::ProductHunt::Client)
    end

    it 'resets the client' do
      step = Pushpop::ProductHunt::Step.new do
        #nothing
      end

      expect(step.client).to receive(:reset)
      step.run
    end
  end


  describe '#day' do
    it 'queries for posts by day' do
      step = Pushpop::ProductHunt::Step.new do
        day
      end

      expect(step.client).to receive(:type).with('posts')

      step.run
    end

    it 'queries for posts on a recent date' do
      step = Pushpop::ProductHunt::Step.new do
        day(3)
      end

      expect(step.client).to receive(:option).with('days_ago', 3)

      step.run
    end

    it 'queries for posts for a specific date string' do
      step = Pushpop::ProductHunt::Step.new do
        day('15th May, 2015')
      end

      expect(step.client).to receive(:option).with('day', '2015-05-15')

      step.run
    end

    it 'queries for posts for a Date object' do
      step = Pushpop::ProductHunt::Step.new do
        day(Date.parse('2015-05-15'))
      end

      expect(step.client).to receive(:option).with('day', '2015-05-15')

      step.run
    end
  end

  describe '#posts' do
    it 'queries for all posts' do
      step = Pushpop::ProductHunt::Step.new do
        posts
      end

      expect(step.client).to receive(:type).with('posts')
      expect(step.client).to receive(:identifier).with('all')

      step.run
    end

    it 'queries for posts with a specific URL' do
      step = Pushpop::ProductHunt::Step.new do
        posts 'https://www.example.com'
      end

      expect(step.client).to receive(:option).with('search[url]' => 'https://www.example.com')

      step.run
    end

    it 'queries for posts owned by a user' do
      step = Pushpop::ProductHunt::Step.new do
        user(10)
        posts
      end

      step.run

      expect(step.client.instance_variable_get('@type')).to eq('users')
      expect(step.client.instance_variable_get('@identifier')).to eq(10)
      expect(step.client.instance_variable_get('@subtype')).to eq('posts')
    end
  end

  describe '#post' do
    it 'queries for a post by id' do
      step = Pushpop::ProductHunt::Step.new do
        post 10
      end

      expect(step.client).to receive(:post).with(10)

      step.run
    end

    it 'sets the current post context' do
      step = Pushpop::ProductHunt::Step.new do
        post 10
      end

      step.run
      expect(step.client._post).to eq(10)
    end
  end

  describe '#users' do
    it 'gets a list of users' do
      step = Pushpop::ProductHunt::Step.new do
        users
      end

      expect(step.client).to receive(:type).with('users')

      step.run
    end
  end

  describe '#user' do
    it 'gets a single user' do
      step = Pushpop::ProductHunt::Step.new do
        user 10
      end

      expect(step.client).to receive(:user).with(10)

      step.run
    end

    it 'sets the current user context' do
      step = Pushpop::ProductHunt::Step.new do
        user 10
      end
      
      step.run
      expect(step.client._user).to eq(10)
    end
  end

  describe '#collections' do
    it 'gets all collections' do
      step = Pushpop::ProductHunt::Step.new do
        collections
      end

      expect(step.client).to receive(:type).with('collections')

      step.run
    end

    it 'queries for collections created by a user' do
      step = Pushpop::ProductHunt::Step.new do
        user(10)
        collections
      end

      step.run

      expect(step.client.instance_variable_get('@type')).to eq('users')
      expect(step.client.instance_variable_get('@identifier')).to eq(10)
      expect(step.client.instance_variable_get('@subtype')).to eq('collections')
    end

    it 'queries for collections containing a post' do
      step = Pushpop::ProductHunt::Step.new do
        post(10)
        collections
      end

      step.run

      expect(step.client.instance_variable_get('@type')).to eq('posts')
      expect(step.client.instance_variable_get('@identifier')).to eq(10)
      expect(step.client.instance_variable_get('@subtype')).to eq('collections')
    end
  end

  describe '#featured_collections' do
    it 'gets the featured collections' do
      step = Pushpop::ProductHunt::Step.new do
        featured_collections
      end

      expect(step.client).to receive(:type).with('collections')
      expect(step.client).to receive(:option).with('search[featured]' => true)

      step.run
    end
  end

  describe 'options functions' do
    it 'sets the per page value' do
      step = Pushpop::ProductHunt::Step.new do
        per_page 100
      end 

      expect(step.client).to receive(:option).with('per_page', 100)

      step.run
    end

    it 'sets the minimum id' do
      step = Pushpop::ProductHunt::Step.new do
        newer_than 54321
      end

      expect(step.client).to receive(:option).with('newer', 54321)

      step.run
    end

    it 'sets the maximum id' do
      step = Pushpop::ProductHunt::Step.new do
        older_than 98765
      end

      expect(step.client).to receive(:option).with('older', 98765)

      step.run
    end

    it 'sets the sort and defaults to asc' do
      step = Pushpop::ProductHunt::Step.new do
        sort 'created_at'
      end

      expect(step.client).to receive(:option).with('sort_by', 'created_at')
      expect(step.client).to receive(:option).with('order', 'asc')

      step.run
    end

    it 'can be overridden to order by desc' do
      step = Pushpop::ProductHunt::Step.new do
        sort 'created_at', 'desc'
      end

      expect(step.client).to receive(:option).with('sort_by', 'created_at')
      expect(step.client).to receive(:option).with('order', 'desc')

      step.run
    end
  end
end
