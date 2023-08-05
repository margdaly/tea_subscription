require 'rails_helper'

RSpec.describe 'POST api/v0/subscribe' do
  let(:customer) { create(:customer) }
  let(:tea) { create(:tea) }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'creating a subscription' do
    scenario 'happy path' do

      subscription_params = {
        frequency: 'monthly',
        customer_id: customer.id,
        tea_id: tea.id
      }

      post '/api/v0/subscribe', headers: headers, params: JSON.generate(subscription_params)

      new_subscription = JSON.parse(response.body, symbolize_names: true)
      new_sub = Subscription.last

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(new_subscription).to be_a(Hash)
      expect(new_subscription[:data][:id]).to eq(new_sub.id.to_s)
      expect(new_subscription[:data][:type]).to eq('subscription')
      expect(new_subscription[:data][:attributes]).to be_a(Hash)

      attributes = new_subscription[:data][:attributes]
      expect(attributes[:customer_id]).to eq(customer.id)
      expect(attributes[:tea_id]).to eq(tea.id)
      expect(attributes[:title]).to eq(tea.title)
      expect(attributes[:price]).to eq('$49.56')
      expect(attributes[:status]).to eq('active')
      expect(attributes[:frequency]).to eq('monthly')
    end

    scenario 'sad path' do

      subscription_params = {
        frequency: 'monthly',
        customer_id: customer.id,
        tea_id: -57
      }

      post '/api/v0/subscribe', headers: headers, params: JSON.generate(subscription_params)

      failure = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(failure).to be_a(Hash)
      expect(failure[:errors]).to be_an(Array)
      expect(failure[:errors][0]).to be_a(Hash)
      expect(failure[:errors][0][:status]).to eq('404')
      expect(failure[:errors][0][:title]).to eq('Record Invalid')
      expect(failure[:errors][0][:detail]).to eq('Validation failed: Tea must exist')
    end
  end
end