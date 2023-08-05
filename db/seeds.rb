
Subscription.destroy_all
Tea.destroy_all
Customer.destroy_all

green = Tea.create!(title: 'Green Tea', description: 'caffinated', region: 'China', brew_time: 7)
black = Tea.create!(title: 'Black Tea', description: 'caffinated', region: 'India', brew_time: 5)
oolong = Tea.create!(title: 'Oolong Tea', description: 'herbal', region: 'Taiwan', brew_time: 4)
mint = Tea.create!(title: 'Mint Tea', description: 'herbal', region: 'Morocco', brew_time: 3)
chamomile = Tea.create!(title: 'Chamomile Tea', description: 'herbal', region: 'Egypt', brew_time: 3)
sleepytime = Tea.create!(title: 'Sleepytime Tea', description: 'herbal', region: 'USA', brew_time: 6)

florie = Customer.create!(
  first_name: 'Florence',
  last_name: 'Everett',
  address: '123 Main St',
  email: 'feefee@mail.com'
)

Tea.all.each do |tea|
  tea.subscriptions.create!(frequency: 'monthly', customer_id: florie.id)
end

harriet = Customer.create!(
  first_name: 'Harriet',
  last_name: 'Murphy',
  address: '24 Beachwood Ave',
  email: 'haphy@mail.com'
)

harriet.subscriptions.create!(tea_id: mint.id, frequency: 'monthly')
harriet.subscriptions.create!(tea_id: chamomile.id, frequency: 'monthly')
harriet.subscriptions.create!(tea_id: sleepytime.id, frequency: 'weekly', status: false)

matilda = Customer.create!(
  first_name: 'Matilda',
  last_name: 'Hurley',
  address: '99 Pine St',
  email: 'math@test.com'
)

matilda.subscriptions.create!(tea_id: green.id)
matilda.subscriptions.create!(tea_id: black.id)
matilda.subscriptions.create!(tea_id: oolong.id)
