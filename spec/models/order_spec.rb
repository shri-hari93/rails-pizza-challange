# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'when order has no items' do
    it 'estimates total_price has 0.0' do
      order = described_class.create!
      expect(order.estimate_total_price).to eq(0.0)
    end
  end

  context 'when order has Salami Large' do
    let!(:order) do
      order = described_class.new
      order.items.build(name: 'Salami', size: 'Large')
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.total_price).to eq(6 * 1.3)
    end
  end

  context 'when order has Salami Large with ingredients Cheese' do
    let!(:order) do
      order = described_class.new
      order.items.build(name: 'Salami', size: 'Large', add: ['Cheese'])
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.total_price).to eq((6 + 2) * 1.3)
    end
  end

  context 'when order has Salami Large with ingredients Cheese but no Onions' do
    let!(:order) do
      order = described_class.new
      order.items.build(name: 'Salami', size: 'Large', add: ['Cheese'], remove: ['Onions'])
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.total_price).to eq((6 + 2) * 1.3)
    end
  end

  context 'when order, Salami Large with ingredients has discount' do
    let!(:order) do
      order = described_class.new(discount_code: 'SAVE5')
      order.items.build(name: 'Salami', size: 'Large', add: ['Cheese'], remove: ['Onions'])
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.total_price).to eq(((6 + 2) * 1.3) * 0.95)
    end
  end

  context 'when order, 2 X Salami Small with ingredients has discount and promotion' do
    let!(:order) do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: ['2FOR1'])
      items = (1..2).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.build(items)
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.estimate_total_price).to eq(((2 * (6 + 2) * 0.7) - (6 * 0.7)) * 0.95)
    end
  end

  context 'when order, 3 X Salami Small with ingredients has discount and promotion' do
    let!(:order) do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: ['2FOR1'])
      items = (1..3).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.build(items)
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.estimate_total_price).to eq(((3 * (6 + 2) * 0.7) - (6 * 0.7)) * 0.95)
    end
  end

  context 'when order, 4 X Salami Small with ingredients has discount and promotion' do
    let!(:order) do
      order = described_class.new(discount_code: 'SAVE5', promotion_code: ['2FOR1'])
      items = (1..4).collect { { name: 'Salami', size: 'Small', add: ['Cheese'], remove: ['Onions'] } }
      order.items.build(items)
      order.save!
      order
    end

    it 'estimates total_price' do
      expect(order.total_price).to eq(((4 * ((6 + 2) * 0.7)) - 2 * (6 * 0.7)) * 0.95)
    end
  end

  context 'when order has single item (Large Tonno)' do
    let!(:order) do
      order = described_class.new
      order.items.build(name: 'Tonno', size: 'Large')
      order.save!
      order
    end

    it 'estimates total_price as 10.40' do
      expect(order.total_price.round(2)).to eq(10.40)
    end
  end

  context 'when order has many items with ingredients' do
    let!(:order) do
      order = described_class.new
      order.items.build(name: 'Margherita', size: 'Large', add: %w[Onions Cheese Olives])
      order.items.build(name: 'Tonno', size: 'Medium', remove: %w[Onions Olives])
      order.items.build(name: 'Margherita', size: 'Small')
      order.save!
      order
    end

    it 'estimates total_price as 25.15' do
      expect(order.total_price.round(2)).to eq(25.15)
    end
  end

  context 'when order has many items along with promotion and discount' do
    let!(:order) do
      order = described_class.new(promotion_code: ['2FOR1'], discount_code: 'SAVE5')
      order.items.build(name: 'Salami', size: 'Medium', add: ['Onions'], remove: ['Cheese'])
      order.items.build(name: 'Salami', size: 'Small')
      order.items.build(name: 'Salami', size: 'Small')
      order.items.build(name: 'Salami', size: 'Small')
      order.items.build(name: 'Salami', size: 'Small', add: ['Olives'])
      order.save!
      order
    end

    it 'estimates total_price as 16.29' do
      expect(order.total_price.round(2)).to eq(16.29)
    end
  end
end
