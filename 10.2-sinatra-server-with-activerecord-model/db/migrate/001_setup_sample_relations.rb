class SetupSampleRelations < ActiveRecord::Migration[4.2]
  def up
    create_table :cards do |t|
      t.float :limit
      t.datetime :date_due
      t.integer :pin
      t.string :card_number
    end

    create_table :txns do |t|
      t.datetime :purchase_date
      t.float :amount
      t.string :store
      t.integer :card_id
    end
  end

  def down
    drop_table :cards
    drop_table :txns
  end
end
