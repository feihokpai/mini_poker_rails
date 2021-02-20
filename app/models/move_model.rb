class MoveModel < ApplicationRecord
    self.table_name = "moves"
    belongs_to :initialHand, :class_name => "HandModel", :foreign_key => "initial_hand_id", required: true
    belongs_to :deckHand, :class_name => "HandModel", :foreign_key => "deck_hand_id", required: true
    belongs_to :bestHand, :class_name => "HandModel", :foreign_key => "best_hand_id", required: true

    def initialize( params={} )
        validate_initialize( params )
        super(params)
    end
    
    private

    def validate_initialize( params )
        handCardsString = params[:hand_cards]
        deckCardsString = params[:deck_cards]
        bestMoveCardsString = params[:best_move_cards]
        ValidateUtil.raiseIfValueIsNotA( handCardsString, String )
        ValidateUtil.raiseIfValueIsNotA( deckCardsString, String )
        ValidateUtil.raiseIfValueIsNotA( bestMoveCardsString, String )
    end
end
