# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :order

  validates :name, presence: true
  validates :size, presence: true
end
