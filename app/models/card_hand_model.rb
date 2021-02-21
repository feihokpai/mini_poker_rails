class CardHandModel < ApplicationRecord
    self.table_name = "cards_hands"
    belongs_to :card, :class_name => "CardModel", :foreign_key => "card_id", required: true
    belongs_to :hand, :class_name => "HandModel", :foreign_key => "hand_id", required: true
end
