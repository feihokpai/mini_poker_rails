class MoveModel < ApplicationRecord
    self.table_name = "moves"
    belongs_to :initialHand, :class_name => "HandModel", :foreign_key => "initial_hand_id", required: true
    belongs_to :deckHand, :class_name => "HandModel", :foreign_key => "deck_hand_id", required: true
    belongs_to :bestHand, :class_name => "HandModel", :foreign_key => "best_hand_id", required: true

    
    private

end
