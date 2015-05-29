require 'spec_helper'
require 'webmock/rspec'

describe Pushpop::ProductHunt::Client do

  before(:each) do
    stub_request(:get, /.*api\.producthunt\.com.*/)
  end

  describe 'internal functions' do
    client = nil
    before(:each) do
      client = Pushpop::ProductHunt::Client.new('12345')
    end

    it 'resets state values' do
      client.user(123)
      client.post(321)

      client.reset

      expect(client._user).to be_nil
      expect(client._post).to be_nil  
    end

    describe '#set_contextual_identifier' do
      it 'scopes user queries' do
        client.user(10)
        client.type('posts')

        expect(client.instance_variable_get('@type')).to eq('users')
        expect(client.instance_variable_get('@identifier')).to eq(10)
        expect(client.instance_variable_get('@subtype')).to eq('posts')
      end

      it 'scopes post queries' do
        client.post(10)
        client.type('collections')

        expect(client.instance_variable_get('@type')).to eq('posts')
        expect(client.instance_variable_get('@identifier')).to eq(10)
        expect(client.instance_variable_get('@subtype')).to eq('collections')
      end

      it 'doesnt scope thins that arent defined as scopable' do
        client.user(10)
        client.type('comments')

        expect(client.instance_variable_get('@type')).to eq('comments')
      end
    end
  end

  describe 'query building functions' do
    client = nil
    before(:each) do
      client = Pushpop::ProductHunt::Client.new('12345')
    end

    describe 'type' do
      it 'sets the type of resource to request' do
        client.type('test')
        expect(client.instance_variable_get('@type')).to eq('test')  
      end 

      it 'will set contextual identifiers' do
        expect(client).to receive(:set_contextual_identifier)
        client.type('test')
      end
    end

    describe 'subtype' do
      it 'sets the subtype to request' do
        client.subtype('test')
        expect(client.instance_variable_get('@subtype')).to eq('test')
      end
    end

    describe 'identifier' do
      it 'sets the resource identifier to request' do
        client.identifier(10)
        expect(client.instance_variable_get('@identifier')).to eq(10)
      end
    end

    describe 'user' do
      it 'sets the user context' do
        client.user(10)
        expect(client._user).to eq(10) 
      end

      it 'sets the resource type to users' do
        client.user(10)
        expect(client.instance_variable_get('@type')).to eq('users')
      end

      it 'sets the resource identifier to the user id' do
        client.user(10)
        expect(client.instance_variable_get('@identifier')).to eq(10)
      end
    end

    describe 'post' do
      it 'sets the post context' do
        client.post(10)
        expect(client._post).to eq(10) 
      end

      it 'sets the resource type to posts' do
        client.post(10)
        expect(client.instance_variable_get('@type')).to eq('posts')
      end

      it 'sets the resource identifier to the post id' do
        client.post(10)
        expect(client.instance_variable_get('@identifier')).to eq(10)
      end
    end
  end
end
