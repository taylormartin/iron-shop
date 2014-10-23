class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.boolean :status
      t.integer :user_id

      t.timestamps
    end
  end
end
