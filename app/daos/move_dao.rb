class MoveDao
    def saveBestResult( handCards, deckCards, bestMove)
        ActiveRecord::Base.transaction do
            initialHandModel = saveHand( handCards )
            deckHandModel = saveHand( deckCards )
            besHandModel = saveHand( bestMove )
            moveModel = MoveModel.new( { initialHand: initialHandModel, deckHand: deckHandModel, bestHand: besHandModel } )
            moveModel.save!()
        end
    end

    private

    def saveHand( cardsArray )
        validate_saveHand( cardsArray )
        newHandModel = HandModel.new
        handCardModelsArray = []
        for card in cardsArray
            handCardModelsArray << createHandCardModel( card, newHandModel )
        end
        newHandModel.save!()
        for handCardModel in handCardModelsArray
            handCardModel.save!()
        end
        return newHandModel
    end

    def validate_saveHand( cardsArray )
        ValidateUtil.raiseIfIsNotAnArrayWithOnly( cardsArray, Card )
        ValidateUtil.raiseIfArrayHasADifferentSize( cardsArray, Hand::NUMBER_OF_CARDS )
    end

    def createHandCardModel( card, newHandModel )
        suitModel = SuitModel.where( letter: card.suit ).first
        cardModel = CardModel.where( { number: card.numberAsInteger, suit: suitModel } ).first
        newCardHandModel = CardHandModel.new( card: cardModel, hand: newHandModel )
        return newCardHandModel
    end
end