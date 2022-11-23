class CreateStockPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_prices do |t|
      t.float :value, null: false

      t.timestamps
    end
  end
end
