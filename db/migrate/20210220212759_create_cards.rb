class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.integer :number
      t.references :suit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
