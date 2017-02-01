class CreateCurrencies < ActiveRecord::Migration[5.0]
  def self.up
    create_table :currencies do |t|
      t.string   "code",          limit: 30,                                         null: false
      t.datetime "last_updated"
      t.decimal  "val",                      precision: 7, scale: 2
      t.decimal  "forced_val",               precision: 7, scale: 2
      t.datetime "forced_till"
      t.boolean  "forced",                                           default: false, null: false
      t.string   "description"
      t.boolean  "update_failed",                                    default: true,  null: false
      
      t.timestamps
    end

    add_index :currencies, :code, unique: true, name: "index_currencies_on_code"
  end
  
  def self.down
    drop_table :currencies
  end
end
