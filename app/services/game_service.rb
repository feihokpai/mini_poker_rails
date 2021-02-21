require_relative "generic_service.rb"
require_relative "invalid_card_code_line_exception.rb"
require_relative "../daos/move_dao.rb"

class GameService < GenericService
    def analyzeBestMove( arrayOfCards )
        validate_analyzeBestMove( arrayOfCards )
        initalHand = Hand.new( arrayOfCards[0..4] )     
        deckHand = Hand.new( arrayOfCards[5..9]   )
        bestResult = CardCombination.bestMoveUsingInitialHandAndDeck( initalHand, deckHand )
        saveBestResult( bestResult )
        return bestResult
    end

    def validateLineOfCardCodes( cardCodesArray )        
        lineString = cardCodesArray.join(" ")        
        if cardCodesArray.size != 10            
            amountOfLines = cardCodesArray.size        
            message = "It's allowed only 10 cards per line. Found: #{amountOfLines}"
            raise InvalidCardCodeLineException.new( lineString, message ) 
        end
        duplicates = cardCodesArray.select{|element| cardCodesArray.count(element) > 1 }
        if duplicates.size > 0
            duplicateValue = duplicates.first
            detachItemInArray(cardCodesArray, duplicateValue)            
            message = "It's not allowed duplicate values. Found: #{duplicateValue}"
            lineString = cardCodesArray.join(" ")        
            raise InvalidCardCodeLineException.new( lineString, message ) 
        end
    end

    def convertCardCodesStringOnCardsArray( cardCodesString )   
        validate_convertCardCodesStringOnCardsArray( cardCodesString )           
        allCodeCards = cardCodesString.split(" ") 
        return convertOnCardsArray( allCodeCards )
    end

    def convertOnCardsArray( cardCodesArray )        
        cardsArray = []
        for codeCard in cardCodesArray
            begin
                cardsArray << Card.new( codeCard )
            rescue ArgumentError => exception  
                detachItemInArray( cardCodesArray, codeCard )                              
                lineWithError = cardCodesArray.join(" ")
                raise InvalidCardCodeLineException.new( lineWithError )
            end
        end
        return cardsArray
    end

    private 

    def saveBestResult( bestResult )
        validate_saveBestResult( bestResult )
        dao = MoveDao.new
        dao.saveBestResult( bestResult[:hand], bestResult[:deck], bestResult[:move] )
    end

    def validate_saveBestResult( bestResult )
        ValidateUtil.raiseIfValueIsNotA( bestResult, Hash )
        ValidateUtil.raiseIfValueIsNotA( bestResult[:combination], CardCombination )
        ValidateUtil.raiseIfIsNotAnArrayWithOnly( bestResult[:move], Card )
    end

    def detachItemInArray( array, value )
        positionOfItem = array.find_index( value )
        newValue = "|#{value}|"
        array[ positionOfItem ] = newValue
    end

    def validate_convertCardCodesStringOnCardsArray( cardCodesString )  
        ValidateUtil.raiseIfValueIsNotA( cardCodesString, String )
    end

    def validate_analyzeBestMove( arrayOfCards )
        invalidTypeMessage = "It was expected an array of Cards. Received one #{arrayOfCards.class} "
        raise invalidTypeMessage if not Card.isArrayOfCards( arrayOfCards )
        numberOfCards = arrayOfCards.size
        raise "It was expected 10 cards, but received: #{numberOfCards}" if numberOfCards != 10
    end

end