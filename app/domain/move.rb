class Move < DomainObject
    attr_reader :initialHand, :deckHand, :bestHand, :bestCombination

    def initialize( initialHand, deckHand, bestHand=nil, bestCombination=nil )
        validate_initialize( initialHand, deckHand, bestHand, bestCombination )
        @initialHand = initialHand
        @deckHand = deckHand
        self.bestHand=( bestHand )
        @bestCombination = bestCombination
    end

    def bestHand=( value )
        validate_setBestHand( value )
        @bestHand = value 
    end

    def calculateBestMove( )
        bestResults = []
        bestResults[0] = bestMoveTradingNCards( 0 )
        bestResults[1] = bestMoveTradingNCards( 1 )
        bestResults[2] = bestMoveTradingNCards( 2 )
        bestResults[3] = bestMoveTradingNCards( 3 )
        bestResults[4] = bestMoveTradingNCards( 4 )
        bestResults[5] = bestMoveTradingNCards( 5 )
        orderedMoves = bestResults.sort_by { |result| result[:combination].pontuation }
        bestMove = orderedMoves.last
        self.bestHand=( bestMove[:move] )
        @bestCombination = bestMove[:combination]
    end

    def bestMoveTradingNCards( numberOfCards )        
        cardCombination = CardCombination.defineCombination( @initialHand )          
        bestResult = { :combination => cardCombination, :move => @initialHand }
        return bestResult if numberOfCards == 0

        cardIndexes = [0,1,2,3,4]
        possibleCombinationsArray = cardIndexes.combination( numberOfCards ).to_a()

        for indexesToTrade in possibleCombinationsArray
            newHand = tradeNCardsWithDeck( indexesToTrade )
            newCombination = CardCombination.defineCombination( newHand )
            if newCombination.pontuation > bestResult[:combination].pontuation
                bestResult[:combination] = newCombination
                bestResult[:move] = newHand
            end
        end
        return bestResult
    end

    def tradeNCardsWithDeck( indexesToTrade )
        copyOfInitialHandCardsArray = @initialHand.cards.clone()
        nextDeckCardsIndex = 0
        for index in indexesToTrade
            copyOfInitialHandCardsArray[index] = @deckHand.cards[ nextDeckCardsIndex ]                
            nextDeckCardsIndex += 1
        end
        return Hand.new( copyOfInitialHandCardsArray )
    end

    private

    def validate_initialize( initialHand, deckHand, bestHand, bestCombination )
        ValidateUtil.raiseIfValueIsNotA( initialHand, Hand )
        ValidateUtil.raiseIfValueIsNotA( deckHand, Hand )
        allCards = initialHand.cards + deckHand.cards
        ValidateUtil.raiseIfNotAllValuesInArrayAreUnique( allCards )
        validate_setBestHand( bestHand )
        if bestCombination.present?
            ValidateUtil.raiseIfValueIsNotA( bestCombination, CardCombination )
        end
    end

    def validate_setBestHand( hand )
        if bestHand.present?
            ValidateUtil.raiseIfValueIsNotA( hand, Hand )            
            for card in hand.cards
                validateIfCardExistsInInititalHandOrDeckHand( card )                
            end
        end
    end

    def validateIfCardExistsInInititalHandOrDeckHand( card )
        allCardsInitialAndDeck = @initialHand.cards + @deckHand.cards
        if not( allCardsInitialAndDeck.include?( card ) )
            message = "It's not possible to add in a Best Hand"
            message += " a card that doesn't exist in initial hand or deck hand: #{card}"
            raise ArgumentError.new( message )
        end 
    end

end