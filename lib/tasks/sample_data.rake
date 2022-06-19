# frozen_string_literal: true

namespace :sample_data do
  desc 'Create sample data for /orders page'
  task create: :environment do
    2.times.each do
      order = Order.new
      order.items.build(name: 'Tonno', size: 'Large', add: ['Onions'], remove: ['Cheese'])
      order.items.build(name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'])
      order.save!

      order = Order.new(promotion_code: ['2FOR1'])
      order.items.build(name: 'Salami', size: 'Small', add: ['Onions'], remove: ['Cheese'])
      order.items.build(name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'])
      order.save!
    end
  end
end
