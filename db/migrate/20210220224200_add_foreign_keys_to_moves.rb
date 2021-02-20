class AddForeignKeysToMoves < ActiveRecord::Migration[6.1]
  def change
      add_reference :moves, :initial_hand, references: :hands
      add_reference :moves, :deck_hand, references: :hands
      add_reference :moves, :best_hand, references: :hands
  end
end
