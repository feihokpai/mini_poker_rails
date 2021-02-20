class MoveDao
    def saveBestResult( handCards, deckCards, bestMove)
        handCardsString = Card.convertCardsArrayToString( handCards )
        deckCardsString = Card.convertCardsArrayToString( deckCards )
        bestMoveString = Card.convertCardsArrayToString( bestMove )
        params = { "hand_cards": handCardsString, "deck_cards": deckCardsString, "best_move_cards": bestMoveString}
        newMove = MoveModel.new( params )
        newMove.save()
    end
end