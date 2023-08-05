class Subscription < ApplicationRecord
  PRICES = {
    'weekly' => 214.76,
    'monthly' => 49.56,
    'seasonal' => 16.52
  }

  belongs_to :customer
  belongs_to :tea

  enum frequency: ['weekly', 'monthly', 'seasonal']

  def title
    tea.title
  end

  def price
    "$#{PRICES[frequency]}"
  end

  def status
    if status?
      'active'
    else 
      'cancelled'
    end
  end
end
