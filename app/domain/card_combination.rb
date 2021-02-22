class CardCombination

    attr_reader :pontuation, :name, :code

    def initialize( pontuation, name, code )
        @pontuation = pontuation
        @name = name
        @code = code
    end

    HIGHEST_CARD = CardCombination.new( 1, "Highest-card", "HC" )
    ONE_PAIR = CardCombination.new( 2, "One Pair", "OP" )
    TWO_PAIRS = CardCombination.new( 3, "Two pairs", "TP" )
    THREE_OF_A_KIND = CardCombination.new( 4, "Three of a kind", "TK" )
    STRAIGHT = CardCombination.new( 5, "Straight", "ST" )
    FLUSH = CardCombination.new( 6, "Flush", "FL" )
    FULL_HOUSE = CardCombination.new( 7, "Full House", "FU" )
    FOUR_OF_A_KIND = CardCombination.new( 8, "Four of a kind", "FK" )
    STRAIGHT_FLUSH = CardCombination.new( 9, "Straight Flush", "SF" )
    ROYAL_STRAIGHT_FLUSH = CardCombination.new( 10, "Royal Straight Flush", "RS" )

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

    private

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