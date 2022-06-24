# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
when 'development'
  order = Order.new
  order.items.build(name: 'Tonno', size: 'Large')
  order.save!

  order = Order.new
  order.items.build(name: 'Margherita', size: 'Large', add: ['Onions', 'Cheese', 'Olives'])
  order.items.build(name: 'Tonno', size: 'Medium', remove: ['Onions', 'Olives'])
  order.items.build(name: 'Margherita', size: 'Small')
  order.save!

  order = Order.new(promotion_code: ['2FOR1'], discount_code: 'SAVE5')
  order.items.build(name: 'Salami', size: 'Medium', add: ['Onions'], remove: ['Cheese'])
  order.items.build(name: 'Salami', size: 'Small')
  order.items.build(name: 'Salami', size: 'Small')
  order.items.build(name: 'Salami', size: 'Small')
  order.items.build(name: 'Salami', size: 'Small', add: ['Olives'])
  order.save!
end
