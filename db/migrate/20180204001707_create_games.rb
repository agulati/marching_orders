class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :num_players, null: false
      t.text    :state,       null: false
      t.string  :channel,     null: false
      t.boolean :active,      null: false
      t.timestamps
    end
  end
end
