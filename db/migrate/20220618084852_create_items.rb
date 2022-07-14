class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :size, null: false
      t.string :add, array: true
      t.string :remove, array: true
      t.references :order, type: :uuid
      t.timestamps
    end
  end
end
