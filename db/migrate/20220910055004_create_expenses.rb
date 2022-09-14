class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.datetime :incurred_at
      t.string :description, null: false, default: ""
      t.decimal :total_amount, precision: 10, scale: 2

      t.integer :incurred_by_id, foreign_key: true
      t.integer :paid_by_id, foreign_key: true

      t.references :user
      t.timestamps
    end
  end
end
