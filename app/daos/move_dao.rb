class MoveDao < DaoInterface

    def save( moveDomain )
        puts "O save de MoveDao deveria ter sido executado, mas não foi porque ainda não foi implementado"
    end

    def saveBestResult( initialHand, deckHand, bestHand)
        ActiveRecord::Base.transaction do
            initialHandModel = saveHand( initialHand )
            deckHandModel = saveHand( deckHand )
            besHandModel = saveHand( bestHand )
            moveModel = MoveModel.new( { initialHand: initialHandModel, deckHand: deckHandModel, bestHand: besHandModel } )
            moveModel.save!()
        end
    end

    private

    def saveHand( hand )
        validate_saveHand( hand )
        newHandModel = HandModel.new
        handCardModelsArray = []
        for card in hand.cards
            handCardModelsArray << createHandCardModel( card, newHandModel )
        end
        newHandModel.save!()
        for handCardModel in handCardModelsArray
            handCardModel.save!()
        end
        return newHandModel
    end

    def validate_saveHand( hand )
        ValidateUtil.raiseIfValueIsNotA( hand, Hand )
    end

    def createHandCardModel( card, newHandModel )
        suitModel = SuitModel.where( letter: card.suit ).first
        cardModel = CardModel.where( { number: card.numberAsInteger, suit: suitModel } ).first
        newCardHandModel = CardHandModel.new( card: cardModel, hand: newHandModel )
        return newCardHandModel
    end
end