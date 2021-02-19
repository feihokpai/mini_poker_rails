require_relative "generic_service.rb"
require_relative "invalid_card_code_line_exception.rb"

class GameService < GenericService
    def analyzeBestMove( arrayOfCards )
        validate_analyzeBestMove( arrayOfCards )
        handCards = arrayOfCards[0..4]        
        deckCards = arrayOfCards[5..9]        
        bestMove = CardCombination.bestMoveUsingHandAndDeck( handCards, deckCards )
        return bestMove
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

    def detachItemInArray( array, value )
        positionOfItem = array.find_index( value )
        newValue = "|#{value}|"
        array[ positionOfItem ] = newValue
    end

    def validate_analyzeBestMove( arrayOfCards )
        invalidTypeMessage = "It was expected an array of Cards. Received one #{arrayOfCards.class} "
        raise invalidTypeMessage if not Card.isArrayOfCards( arrayOfCards )
        numberOfCards = arrayOfCards.size
        raise "It was expected 10 cards, but received: #{numberOfCards}" if numberOfCards != 10
    end



end