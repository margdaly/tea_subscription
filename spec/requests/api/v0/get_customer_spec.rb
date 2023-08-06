require 'rails_helper'

RSpec.describe 'GET api/v0/customers/:id/' do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'returns a customer and their subscriptions' do
    scenario 'happy path' do
      customer = create(:customer)
      tea1 = create(:tea)
      tea2 = create(:tea)
      tea3 = create(:tea)

      customer.subscriptions.create!(frequency: 'monthly', tea_id: tea1.id)
      customer.subscriptions.create!(frequency: 'weekly', tea_id: tea2.id)
      customer.subscriptions.create!(frequency: 'seasonal', tea_id: tea3.id)
      Subscription.last.update(status: false)

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
      expect(attributes[:subscriptions].count).to eq(3)
      
      sub1 = attributes[:subscriptions][0]
      require 'pry'; binding.pry
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