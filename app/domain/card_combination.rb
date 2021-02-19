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

    def self.move( arrayOfCards )
        numericalCombinations = self.getNumericalDuplicatesInHand( arrayOfCards )        
        if numericalCombinations.empty?
            return self.moveWithZeroNumericalCombinations( arrayOfCards )
        end
        return self.moveWithNumericalCombinations( arrayOfCards, numericalCombinations )
    end

    def self.bestMoveUsingHandAndDeck( handCards, deckCards )
        self.validateHandOrSuitCards( deckCards )
        bestMoves = []
        bestMoves[0] = self.bestMoveTradingNCards( handCards, deckCards, 0 )
        bestMoves[1] = self.bestMoveTradingNCards( handCards, deckCards, 1 )
        bestMoves[2] = self.bestMoveTradingNCards( handCards, deckCards, 2 )
        bestMoves[3] = self.bestMoveTradingNCards( handCards, deckCards, 3 )
        bestMoves[4] = self.bestMoveTradingNCards( handCards, deckCards, 4 )
        bestMoves[5] = self.bestMoveTradingNCards( handCards, deckCards, 5 )
        orderedMoves = bestMoves.sort_by { |move| move.pontuation }
        return orderedMoves.last
    end

    private

    def self.bestMoveTradingNCards( handCards, deckCards, numberOfCards )
        bestMove = self.move( handCards )
        return bestMove if numberOfCards == 0

        cardIndexes = [0,1,2,3,4]
        possibleCombinationsArray = cardIndexes.combination( numberOfCards ).to_a()

        for combinationArray in possibleCombinationsArray
            copyOfHandCards = handCards.clone()
            nextDeckCardsIndex = 0
            for index in combinationArray
                puts "array: #{combinationArray}"
                copyOfHandCards[index] = deckCards[ nextDeckCardsIndex ]                
                nextDeckCardsIndex += 1
            end
            newMove = self.move( copyOfHandCards )
            if newMove.pontuation > bestMove.pontuation
                bestMove = newMove
            end
        end
        return bestMove
    end

    def self.moveWithNumericalCombinations( arrayOfCards, numericalCombinations )   
        return ONE_PAIR if numericalCombinations.size == 2
        return THREE_OF_A_KIND if numericalCombinations.size == 3
        uniqueValuesArray = numericalCombinations.uniq
        if numericalCombinations.size == 4
            return FOUR_OF_A_KIND if uniqueValuesArray.size == 1
            return TWO_PAIRS if uniqueValuesArray.size == 2
        end
        return FULL_HOUSE        
    end

    def self.moveWithZeroNumericalCombinations( arrayOfCards )
        suitCombinations = self.getSuitDuplicatesInHand( arrayOfCards )
        isANumericalSequence = self.cardsInNumericalSequence?( arrayOfCards )
        if suitCombinations.size != 5
            return STRAIGHT if isANumericalSequence
            return HIGHEST_CARD
        end
        return self.moveWithFiveSuitCombination( arrayOfCards )
    end

    def self.moveWithFiveSuitCombination( arrayOfCards )
        isANumericalSequence = self.cardsInNumericalSequence?( arrayOfCards )
        return FLUSH if not isANumericalSequence
        orderedNumbers = self.numbersOrderedAsIntegersConsideringTheKing( arrayOfCards )
        isFirstCardNumber10 = orderedNumbers.first == Card::TEN_VALUE
        isLastCardNumber1 = orderedNumbers.last == Card::ACE_PLUS_KING_VALUE
        if (isFirstCardNumber10 && isLastCardNumber1)
            return ROYAL_STRAIGHT_FLUSH 
        end
        return STRAIGHT_FLUSH
    end

    def self.cardsInNumericalSequence?( arrayOfCards )
        orderedNumbers = self.numbersOrderedAsIntegersConsideringTheKing( arrayOfCards )
        return ArrayUtil.isAnArrayWithAllValuesAsIntegersInSequence?( orderedNumbers ) 
    end

    def self.numbersOrdered( arrayOfCards )
        numericalValues = self.numericalValues( arrayOfCards )
        return numericalValues.sort
    end

    def self.numbersOrderedAsIntegersConsideringTheKing( arrayOfCards )
        orderedNumbers = self.numbersOrderedAsIntegers( arrayOfCards )
        includesKing = orderedNumbers.include?( Card::KING_VALUE )       
        if not(includesKing)
            return orderedNumbers
        end
        copyOfOrderedNumbers = orderedNumbers.clone()
        for number in 1..4
            newValue = Card::KING_VALUE + number
            copyOfOrderedNumbers = ArrayUtil.changeValue( copyOfOrderedNumbers, number, newValue )
        end
        reorderedNumbers = copyOfOrderedNumbers.sort
        return reorderedNumbers
    end

    def self.numbersOrderedAsIntegers( arrayOfCards )
        numericalValues = self.numericalValuesAsIntegers( arrayOfCards )
        return numericalValues.sort
    end

    def self.getNumericalDuplicatesInHand( arrayOfCards )
        validateHandOrSuitCards( arrayOfCards )
        numericalValues = self.numericalValues( arrayOfCards )
        numericalCombinations = ArrayUtil.duplicateValues( numericalValues )        
        return numericalCombinations
    end

    def self.numericalValues( arrayOfCards )
        return arrayOfCards.map { |card| card.number  }
    end

    def self.numericalValuesAsIntegers( arrayOfCards )
        return arrayOfCards.map { |card| card.numberAsInteger  }
    end

    def self.getSuitDuplicatesInHand( arrayOfCards )
        self.validateHandOrSuitCards( arrayOfCards )
        suitValues = arrayOfCards.map { |card| card.suit  }
        suitCombinations = ArrayUtil.duplicateValues( suitValues )        
        return suitCombinations
    end

    def self.validateHandOrSuitCards( arrayOfCards )
        self.validateArrayOfCards( arrayOfCards )
        numberOfCards = arrayOfCards.size
        raise "It was expected 5 cards. received: #{numberOfCards}" if numberOfCards != 5
    end

    def self.validateArrayOfCards( arrayOfCards )
        invalidTypeMessage = "It was expected an array of Cards. Received one #{arrayOfCards.class} "
        isNotOneArrayOfCards = not( Card.isArrayOfCards( arrayOfCards ) )
        raise invalidTypeMessage if isNotOneArrayOfCards
    end
end