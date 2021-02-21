class CardCombination

    attr_reader :pontuation, :name

    def initialize( pontuation, name )
        @pontuation = pontuation
        @name = name
    end

    HIGHEST_CARD = CardCombination.new( 1, "Highest-card" )
    ONE_PAIR = CardCombination.new( 2, "One Pair" )
    TWO_PAIRS = CardCombination.new( 3, "Two pairs" )
    THREE_OF_A_KIND = CardCombination.new( 4, "Three of a kind" )
    STRAIGHT = CardCombination.new( 5, "Straight" )
    FLUSH = CardCombination.new( 6, "Flush" )
    FULL_HOUSE = CardCombination.new( 7, "Full House" )
    FOUR_OF_A_KIND = CardCombination.new( 8, "Four of a kind" )
    STRAIGHT_FLUSH = CardCombination.new( 9, "Straight Flush" )
    ROYAL_STRAIGHT_FLUSH = CardCombination.new( 10, "Royal Straight Flush" )

    def to_s
        return "name: #{@name}, pontuation: #{@pontuation}"
    end

    def self.defineCombination( hand )
        numericalCombinations = hand.numericalDuplicates()
        if numericalCombinations.empty?
            return self.moveWithZeroNumericalCombinations( hand )
        end
        return self.moveWithNumericalCombinations( numericalCombinations )
    end


    def self.bestMoveUsingInitialHandAndDeck( initialHand, deckHand )
        self.validate_bestMoveUsingInitialHandAndDeck( initialHand, deckHand )
        bestResults = []
        bestResults[0] = self.bestMoveTradingNCards( handCards, deckCards, 0 )
        bestResults[1] = self.bestMoveTradingNCards( handCards, deckCards, 1 )
        bestResults[2] = self.bestMoveTradingNCards( handCards, deckCards, 2 )
        bestResults[3] = self.bestMoveTradingNCards( handCards, deckCards, 3 )
        bestResults[4] = self.bestMoveTradingNCards( handCards, deckCards, 4 )
        bestResults[5] = self.bestMoveTradingNCards( handCards, deckCards, 5 )
        orderedMoves = bestResults.sort_by { |result| result[:combination].pontuation }
        return orderedMoves.last
    end

    private

    def self.validate_bestMoveUsingInitialHandAndDeck( initialHand, deckHand )
        ValidateUtil.raiseIfValueIsNotA( initalHand, Hand )
        ValidateUtil.raiseIfValueIsNotA( deckHand, Hand )
    end

    def self.bestMoveTradingNCards( initialHand, deckHand, numberOfCards )        
        cardCombination = self.defineCombination( initialHand )  
        bestResult = { :combination => cardCombination, :move => initialHand, :hand => initialHand, :deck => deckHand }
        return bestResult if numberOfCards == 0

        cardIndexes = [0,1,2,3,4]
        possibleCombinationsArray = cardIndexes.combination( numberOfCards ).to_a()

        for indexesToTrade in possibleCombinationsArray
            newHand = self.tradeNCardsWithDeck( initialHand, deckHand, indexesToTrade )
            newCombination = self.defineCombination( newHand )
            if newCombination.pontuation > bestResult[:combination].pontuation
                bestResult[:combination] = newCombination
                bestResult[:move] = copyOfInitialHandCardsArray
            end
        end
        return bestResult
    end

    def self.tradeNCardsWithDeck( initialHand, deckHand, indexesToTrade )
        copyOfInitialHandCardsArray = initialHand.cards.clone()
        nextDeckCardsIndex = 0
        for index in indexesToTrade
            copyOfInitialHandCardsArray[index] = deckHand.cards[ nextDeckCardsIndex ]                
            nextDeckCardsIndex += 1
        end
        return Hand.new( copyOfInitialHandCardsArray )
    end

    def self.moveWithNumericalCombinations( numericalCombinations )   
        return ONE_PAIR if numericalCombinations.size == 2
        return THREE_OF_A_KIND if numericalCombinations.size == 3
        uniqueValuesArray = numericalCombinations.uniq
        if numericalCombinations.size == 4
            return FOUR_OF_A_KIND if uniqueValuesArray.size == 1
            return TWO_PAIRS if uniqueValuesArray.size == 2
        end
        return FULL_HOUSE        
    end

    def self.moveWithZeroNumericalCombinations( hand )
        suitCombinations = hand.suitDuplicates()
        uniqueSuitValues = suitCombinations.uniq()
        allSuitsEquals = suitCombinations.size == 5 && uniqueSuitValues.size == 1
        if allSuitsEquals
            return self.moveWithFiveSuitCombination( hand )
        end
        isANumericalSequence = hand.cardsInNumericalSequence?()
        return STRAIGHT if isANumericalSequence
        return HIGHEST_CARD
    end

    def self.moveWithFiveSuitCombination( hand )
        isANumericalSequence = hand.cardsInNumericalSequence?()
        return FLUSH if not isANumericalSequence
        orderedNumbers = hand.numbersOrderedAsIntegersConsideringTheKing()
        isFirstCardNumber10 = orderedNumbers.first == Card::TEN_VALUE
        isLastCardNumber1 = orderedNumbers.last == Card::ACE_PLUS_KING_VALUE
        if (isFirstCardNumber10 && isLastCardNumber1)
            return ROYAL_STRAIGHT_FLUSH 
        end
        return STRAIGHT_FLUSH
    end

end