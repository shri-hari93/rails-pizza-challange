# frozen_string_literal: true

class Order < ApplicationRecord
  DATA_CONFIG = YAML.safe_load(File.open('data/config.yml')).freeze

  has_many :items, dependent: :destroy

  before_create :estimate_total_price

  scope :open, -> { where(completed: false) }

  def estimate_total_price
    self.total_price = total_price_before_discount * discount
  end

  private

  def total_price_before_discount
    items_price - promotion_deduction
  end

  def items_price
    items.inject(0) do |price, item|
      price + cost_of_pizza(name: item.name, size: item.size, elements: item.add)
    end
  end

  def cost_of_pizza(name:, size:, elements: nil)
    (pizzas(name) + cost_of_ingredients(elements)) * size_multipliers(size)
  end

  def cost_of_ingredients(elements)
    elements&.inject(0) { |price, type| price + ingredients(type) } || 0
  end

  def discount
    1 - (discount_percent.to_f / 100)
  end

  def discount_percent
    discounts(discount_code)&.[] 'deduction_in_percent' || 0
  end

  def promotion_deduction
    promotion_code&.uniq&.filter_map do |code|
      promotion_deduction_per_code(code) if eligible_for_promotion(code)
    end&.sum || 0
  end

  def eligible_for_promotion(code)
    promotions(code).present?
  end

  def total_items_under_promotion(code)
    items.count { |item| item.name == promotions(code)['target'] && item.size == promotions(code)['target_size'] }
  end

  def promotion_deduction_per_code(code)
    reduction = promotions(code)['from'] - promotions(code)['to']
    times = total_items_under_promotion(code) / promotions(code)['from']
    cost_of_pizza(name: promotions(code)['target'], size: promotions(code)['target_size']) * reduction * times
  end

  DATA_CONFIG.each_key do |key|
    define_method(key) { |arg| DATA_CONFIG[key][arg] }
  end
end
