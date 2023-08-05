require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:tea) }
  end

  describe 'attributes' do
    before :all do
      @customer = create(:customer)
      @tea = create(:tea)
      @subscription = Subscription.create!(frequency: 'weekly', customer_id: @customer.id, tea_id: @tea.id)
    end

    it 'returns the title of the tea' do
      expect(@subscription.title).to eq(@tea.title)
    end

    it 'defaults status to active' do
      expect(@subscription.status).to eq('active')
    end

    it 'returns the price based on frequency' do
      expect(@subscription.price).to eq('$214.76')

      @subscription.update(frequency: 'monthly')
      expect(@subscription.price).to eq('$49.56')

      @subscription.update(frequency: 'seasonal')
      expect(@subscription.price).to eq('$16.52')
    end
  end
end
