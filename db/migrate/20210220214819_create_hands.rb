class CreateHands < ActiveRecord::Migration[6.1]
  def change
    create_table :hands do |t|

      t.timestamps
    end
  end
end
