require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'when order has no items' do
    it 'estimates total_price has 0.0' do
      order = described_class.create!
      expect(order.estimate_total_price).to eq(0.0)
    end
  end

  context 'when order has Salami Large' do
    it 'estimates total_price' do
      order = described_class.create!
      order.items.create(name: 'Salami', size: 'Large')
      expect(order.estimate_total_price).to eq(6 * 1.3)
    end
  end

  context 'when order has Salami Large with ingredients Cheese' do
    it 'estimates total_price' do
      order = described_class.create!
      order.items.create(name: 'Salami', size: 'Large', add: ['Cheese'])
      expect(order.estimate_total_price).to eq(6 * 1.3 + 2)
    end
  end

  context 'when order has Salami Large with ingredients Cheese but no Onions' do
    it 'estimates total_price' do
      order = described_class.create!
      order.items.create(name: 'Salami', size: 'Large', add: ['Cheese'], remove: ['Onions'])
      expect(order.estimate_total_price).to eq(6 * 1.3 + 2)
    end
  end

  context 'when order, Salami Large with ingredients has discount' do
    it 'estimates total_price' do
      order = described_class.new(discount_code: 'SAVE5')
      order.save!
      order.items.create(name: 'Salami', size: 'Large', add: ['Cheese'], remove: ['Onions'])
      expect(order.estimate_total_price).to eq((6 * 1.3 + 2) * 0.95)
    end
  end

  context 'when order, 4 X Salami Small with ingredients has discount and promotion' do
    it 'estimates total_price' do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: ['2FOR1'])
      order.save!
      items = (1..4).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.create(items)
      expect(order.estimate_total_price).to eq((4 * (6 * 0.7 + 2) - (6 * 0.7)) * 0.95)
    end
  end

  context 'when order, 4 X Salami Small with ingredients has discount and multiple promotion' do
    it 'estimates total_price' do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: %w[2FOR1 2FOR1])
      order.save!
      items = (1..4).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.create(items)
      expect(order.estimate_total_price).to eq((4 * (6 * 0.7 + 2) - 2 * (6 * 0.7)) * 0.95)
    end
  end

  context 'when order, 2 X Salami Small with ingredients has discount and multiple promotion' do
    it 'estimates total_price' do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: %w[2FOR1 2FOR1])
      order.save!
      items = (1..2).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.create(items)
      expect(order.estimate_total_price).to eq((2 * (6 * 0.7 + 2) - (6 * 0.7)) * 0.95)
    end
  end
end
