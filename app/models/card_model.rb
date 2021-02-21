class CardModel < ApplicationRecord
    self.table_name = "cards"
    belongs_to :suit, :class_name => "SuitModel", :foreign_key => "suit_id", required: true
end