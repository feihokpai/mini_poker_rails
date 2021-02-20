class MoveModel < ApplicationRecord
    self.table_name = "moves"

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
