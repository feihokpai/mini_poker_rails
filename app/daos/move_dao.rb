class MoveDao < DaoInterface

    def initialize
        @handDao = HandDao.new
    end

    def save( moveDomain, transactionActived=false )
        validate_save( moveDomain, transactionActived )
        if !transactionActived
            @transactionActived = true
            ActiveRecord::Base.transaction do
                return saveMove( moveDomain )
            end
        else
            return saveMove( moveDomain )
        end        
    end

    def saveMove( moveDomain )
        initialHandModel = @handDao.save( moveDomain.initialHand, @transactionActived )
        deckHandModel = @handDao.save( moveDomain.deckHand, @transactionActived )
        besHandModel = @handDao.save( moveDomain.bestHand, @transactionActived )
        moveModel = MoveModel.new( { initialHand: initialHandModel, deckHand: deckHandModel, bestHand: besHandModel } )
        return moveModel.save!()
    end

    private

    def validate_save( move, transactionActived )
        ValidateUtil.raiseIfValueIsNotA( move, Move )
        ValidateUtil.raiseIfValueIsNotABoolean( transactionActived )
    end

    # def saveStartingTransaction( moveDomain )
    #     @transactionActived = true
    #     ActiveRecord::Base.transaction do
    #         saveHands( moveDomain )
    #     end
    # end

    # def saveNoStartingTransaction( moveDomain )
    #     saveHands( moveDomain )
    # end

    # def saveBestResult( initialHand, deckHand, bestHand)
    #     ActiveRecord::Base.transaction do
    #         initialHandModel = saveHand( initialHand )
    #         deckHandModel = saveHand( deckHand )
    #         besHandModel = saveHand( bestHand )
    #         moveModel = MoveModel.new( { initialHand: initialHandModel, deckHand: deckHandModel, bestHand: besHandModel } )
    #         moveModel.save!()
    #     end
    # end

    # def saveHand( hand )
    #     validate_saveHand( hand )
    #     newHandModel = HandModel.new
    #     handCardModelsArray = []
    #     for card in hand.cards
    #         handCardModelsArray << createHandCardModel( card, newHandModel )
    #     end
    #     newHandModel.save!()
    #     for handCardModel in handCardModelsArray
    #         handCardModel.save!()
    #     end
    #     return newHandModel
    # end

    # def validate_saveHand( hand )
    #     ValidateUtil.raiseIfValueIsNotA( hand, Hand )
    # end

    # def createHandCardModel( card, newHandModel )
    #     suitModel = SuitModel.where( letter: card.suit ).first
    #     cardModel = CardModel.where( { number: card.numberAsInteger, suit: suitModel } ).first
    #     newCardHandModel = CardHandModel.new( card: cardModel, hand: newHandModel )
    #     return newCardHandModel
    # end
end