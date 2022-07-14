# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders/index.html.erb', type: :view do
  context 'when there are orders' do
    let!(:order) do
      order = Order.new(discount_code: 'SAVE5', promotion_code: %w[2FOR1])
      order.items.build(name: 'Margherita', size: 'Large', add: %w[Onions Cheese Olives])
      order.save!
      order
    end

    let!(:order_without_promotion_and_discount) do
      order = Order.new
      order.items.build(name: 'Tonno', size: 'Large')
      order.save!
      order
    end

    let!(:order_completed) do
      order = Order.new(completed: true)
      order.items.build(name: 'Salami', size: 'Small')
      order.save!
      order
    end

    before do
      order
      order_completed
      order_without_promotion_and_discount
      @orders = Order.open
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'display orders' do
      render template: 'orders/index.html.erb'

      expect(rendered).to match(/#{order.id}/)
      expect(rendered).to match(/#{order_without_promotion_and_discount.id}/)
      expect(rendered).not_to match(/#{order_completed.id}/)
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
