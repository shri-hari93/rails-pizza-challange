# fronzen_string_literal: true

module OrdersHelper
  def display_price_with_currency(price)
    "#{price.round(2)} €"
  end

  def display_time(time, timezone = 'Berlin')
    time.in_time_zone(timezone).strftime('%B %d, %Y %R')
  end

  def display_item(item)
    "#{item.name} (#{item.size})"
  end

  def display_ingredients(option, ingredients)
    "#{option.to_s.capitalize}: #{ingredients.join(', ')}"
  end
end
