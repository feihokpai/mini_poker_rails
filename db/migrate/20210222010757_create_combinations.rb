class CreateCombinations < ActiveRecord::Migration[6.1]
  def change
    create_table :combinations do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
