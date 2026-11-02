class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_id, null: false
      t.integer :amount, null: false
      t.string :status, null: false, default: "pending"
      t.string :qr_url
      t.string :midtrans_transaction_id
      t.datetime :paid_at

      t.timestamps

      t.index :order_id, unique: true
    end
  end
end
