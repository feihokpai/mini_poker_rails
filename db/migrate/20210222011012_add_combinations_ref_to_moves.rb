class AddCombinationsRefToMoves < ActiveRecord::Migration[6.1]
  def change
    add_reference :moves, :combination, null: false, foreign_key: true
  end
end
