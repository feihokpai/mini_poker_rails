class Hand < DomainObject
    NUMBER_OF_CARDS = 5

    attr_reader :cards

    def initialize( cardsArray )
        validate_initialize( cardsArray )
        @cards = cardsArray
    end

    def numericalDuplicates( )
        numericalValues = self.numericalValues( )
        numericalCombinations = ArrayUtil.duplicateValues( numericalValues )        
        return numericalCombinations
    end

    def numericalValues( )
        return @cards.map { |card| card.number  }
    end

    def numericalValuesAsIntegers( )
        return @cards.map { |card| card.numberAsInteger  }
    end

    def numbersOrderedAsIntegers( )
        numericalValues = numericalValuesAsIntegers( )
        return numericalValues.sort
    end

    def suitDuplicates( )
        suitValues = @cards.map { |card| card.suit  }
        suitCombinations = ArrayUtil.duplicateValues( suitValues )        
        return suitCombinations
    end

    def cardsInNumericalSequence?( )
        orderedNumbers = numbersOrderedAsIntegersConsideringTheKing( )
        return ArrayUtil.isAnArrayWithAllValuesAsIntegersInSequence?( orderedNumbers ) 
    end

    def numbersOrderedAsIntegersConsideringTheKing( )
        orderedNumbers = numbersOrderedAsIntegers()
        includesKing = orderedNumbers.include?( Card::KING_VALUE )       
        if not(includesKing)
            return orderedNumbers
        end
        copyOfOrderedNumbers = orderedNumbers.clone()
        copyOfOrderedNumbers = ArrayUtil.changeValue( copyOfOrderedNumbers, Card::ACE_VALUE, Card::ACE_PLUS_KING_VALUE )
        reorderedNumbers = copyOfOrderedNumbers.sort
        return reorderedNumbers
    end

    private

    def validate_initialize( cardsArray )
        ValidateUtil.raiseIfIsNotAnArrayWithOnly( cardsArray, Card )
        ValidateUtil.raiseIfArrayHasADifferentSize( cardsArray, NUMBER_OF_CARDS )
        ValidateUtil.raiseIfNotAllValuesInArrayAreUnique( cardsArray )
    end
    
end