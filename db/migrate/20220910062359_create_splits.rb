class CreateSplits < ActiveRecord::Migration[6.1]
  def change
    create_table :splits do |t|
      t.decimal :amount, precision: 10, scale: 2

      t.references :user
      t.references :expense
      t.timestamps
    end
  end
end
