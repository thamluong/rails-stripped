class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :plan_name
      t.string :stripe_customer_token

      t.timestamps
    end
  end
end
