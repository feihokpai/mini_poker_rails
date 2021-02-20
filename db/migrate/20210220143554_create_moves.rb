class CreateMoves < ActiveRecord::Migration[6.1]
  def change
    create_table :moves do |t|
      t.string :hand_cards
      t.string :deck_cards
      t.string :best_move_cards

      t.timestamps
    end
  end
end
