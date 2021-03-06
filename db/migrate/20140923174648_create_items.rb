class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 7, scale: 2
      t.integer :seller_id

      t.timestamps
    end
  end
end
