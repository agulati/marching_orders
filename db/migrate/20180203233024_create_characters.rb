class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.string  :behavior,  null: false
      t.string  :display,   null: false
      t.timestamps
    end

    create_table :characters do |t|
      t.string      :rank,    null: false
      t.integer     :value,   null: false
      t.string      :display, null: false
      t.references  :action,  null: false
      t.timestamps
    end
  end
end
