class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :orders, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.boolean :completed, default: false
      t.string :promotion_code, array: true
      t.string :discount_code
      t.float :total_price, default: 0.0
      t.timestamps
    end
  end
end
