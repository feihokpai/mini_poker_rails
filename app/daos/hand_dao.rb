class HandDao < DaoInterface

    def save( handDomain, transactionActived=false )
        validate_save( handDomain )
        if !transactionActived
            @transactionActived = true
            ActiveRecord::Base.transaction do
                return saveHand( handDomain )
            end
        else
            return saveHand( handDomain )
        end   
    end

    def saveHand( handDomain )
        newHandModel = HandModel.new

        handCardModelsArray = []
        for card in handDomain.cards
            handCardModelsArray << createHandCardModel( card, newHandModel )
        end
        newHandModel.save!()
        for handCardModel in handCardModelsArray
            handCardModel.save!()
        end
        return newHandModel
    end

    def createHandCardModel( card, newHandModel )
        suitModel = SuitModel.where( letter: card.suit ).first
        cardModel = CardModel.where( { number: card.numberAsInteger, suit: suitModel } ).first
        newCardHandModel = CardHandModel.new( card: cardModel, hand: newHandModel )
        return newCardHandModel
    end

    private

    def validate_save( handDomain )
        ValidateUtil.raiseIfValueIsNotA( handDomain, Hand )
    end
end    