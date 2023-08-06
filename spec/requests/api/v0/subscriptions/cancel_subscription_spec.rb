require 'rails_helper'

RSpec.describe 'PATCH api/v0/cancel' do
  let(:customer) { create(:customer) }
  let(:tea) { create(:tea) }
  let(:subscription) { Subscription.create!(customer_id: customer.id, tea_id: tea.id, frequency: 'seasonal') }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'canceling a subscription' do
    scenario 'happy path' do
      expect(subscription.status).to eq('active')

      patch '/api/v0/cancel', headers: headers, params: JSON.generate({ customer_id: customer.id, tea_id: tea.id })

      updated_sub = JSON.parse(response.body, symbolize_names: true) 

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(updated_sub).to be_a(Hash)
      expect(updated_sub[:data]).to be_a(Hash)
      expect(updated_sub[:data][:id]).to eq(subscription.id.to_s)
      expect(updated_sub[:data][:type]).to eq('subscription')
      expect(updated_sub[:data][:attributes]).to be_a(Hash)

      attributes = updated_sub[:data][:attributes]
      expect(attributes[:customer_id]).to eq(customer.id)
      expect(attributes[:tea_id]).to eq(tea.id)
      expect(attributes[:title]).to eq(tea.title)
      expect(attributes[:price]).to eq('$16.52')
      expect(attributes[:frequency]).to eq('seasonal')
      expect(attributes[:status]).to eq('cancelled')
    end

    scenario 'sad path' do
      patch '/api/v0/cancel', headers: headers, params: JSON.generate({ customer_id: 0, tea_id: tea.id })

      failure = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(failure).to be_a(Hash)
      expect(failure[:errors]).to be_an(Array)
      expect(failure[:errors][0]).to be_a(Hash)
      expect(failure[:errors][0][:status]).to eq('404')
      expect(failure[:errors][0][:title]).to eq('Record Invalid')
      expect(failure[:errors][0][:detail]).to eq("Couldn't find Subscription")
    end
  end
end