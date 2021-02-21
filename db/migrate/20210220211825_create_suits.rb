class CreateSuits < ActiveRecord::Migration[6.1]
  def change
    create_table :suits do |t|
      t.string :name
      t.string :letter

      t.timestamps
    end
  end
end
