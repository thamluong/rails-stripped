class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :receipt_number
      t.decimal  :amount, precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end