require_relative "generic_service.rb"
require_relative "invalid_card_code_line_exception.rb"

class GameService < GenericService
    def analyzeBestMove( arrayOfMoves )
        validate_analyzeBestMove( arrayOfMoves )

    end

    def convertOnCardsArray( cardCodesArray )
        cardsArray = []
        for codeCard in cardCodesArray
            begin
                cardsArray << Card.new( codeCard )
            rescue ArgumentError => exception                
                positionOfProblematicValueInArray = cardCodesArray.find_index( codeCard )
                newValue = "|#{codeCard}|"
                cardCodesArray[ positionOfProblematicValueInArray ] = newValue
                lineWithError = cardCodesArray.join(" ")
                raise InvalidCardCodeLineException.new( lineWithError )
            end
        end
        return cardsArray
    end

    private 

end