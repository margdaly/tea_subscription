require 'rails_helper'

RSpec.describe 'GET api/v0/customers/:id/' do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'returns a customer and their subscriptions' do
    scenario 'happy path' do
      customer = create(:customer)
      tea1 = create(:tea)
      tea2 = create(:tea)

      subscription1 = customer.subscriptions.create!(frequency: 'monthly', tea_id: tea1.id)
      subscription2 = customer.subscriptions.create!(frequency: 'weekly', tea_id: tea2.id)
      subscription2.update!(status: false) #cancel subscription

      get "/api/v0/customers/#{customer.id}", headers: headers

      customer_info = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(customer_info).to be_a(Hash)
      expect(customer_info[:data]).to be_a(Hash)
      expect(customer_info[:data][:id]).to eq(customer.id.to_s)
      expect(customer_info[:data][:type]).to eq('customer')
      expect(customer_info[:data][:attributes]).to be_a(Hash)

      attributes = customer_info[:data][:attributes]
      expect(attributes[:first_name]).to eq(customer.first_name)
      expect(attributes[:last_name]).to eq(customer.last_name)
      expect(attributes[:email]).to eq(customer.email)
      expect(attributes[:address]).to eq(customer.address)
      expect(attributes[:subscriptions]).to be_an(Array)
      
      sub1 = attributes[:subscriptions].first
      expect(sub1).to be_a(Hash)
      expect(sub1[:id]).to eq(subscription1.id)
      expect(sub1[:title]).to be_a(String)
      expect(sub1[:title]).to eq(subscription1.title)
      expect(sub1[:price]).to be_a(String)
      expect(sub1[:price]).to eq(subscription1.price)
      expect(sub1[:status]).to be_a(String)
      expect(sub1[:status]).to eq('active')
      expect(sub1[:frequency]).to be_a(String)
      expect(sub1[:frequency]).to eq('monthly')
      expect(sub1[:customer_id]).to eq(customer.id)
      expect(sub1[:tea_id]).to eq(tea1.id)

      sub2 = attributes[:subscriptions].last
      expect(sub2).to be_a(Hash)
      expect(sub2[:id]).to eq(subscription2.id)
      expect(sub2[:title]).to be_a(String)
      expect(sub2[:title]).to eq(subscription2.title)
      expect(sub2[:price]).to be_a(String)
      expect(sub2[:price]).to eq(subscription2.price)
      expect(sub2[:status]).to be_a(String)
      expect(sub2[:status]).to eq('cancelled')
      expect(sub2[:frequency]).to be_a(String)
      expect(sub2[:frequency]).to eq('weekly')
      expect(sub2[:customer_id]).to eq(customer.id)
      expect(sub2[:tea_id]).to eq(tea2.id)
    end

    scenario 'sad path' do
      get "/api/v0/customers/0", headers: headers

      failure = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(failure).to be_a(Hash)
      expect(failure[:errors]).to be_an(Array)

      error = failure[:errors][0]
      expect(error).to be_a(Hash)
      expect(error[:status]).to eq('404')
      expect(error[:title]).to eq('Record Invalid')
      expect(error[:detail]).to eq('Couldn\'t find Customer with \'id\'=0')
    end
  end
end