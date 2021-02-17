class Card
    attr_reader :number, :suit

    VALID_NUMBERS = ('1'..'9').to_a()
    VALID_LETTER_NUMBERS = ["A","T","J","Q","K"]
    VALID_SUITS = ["C","H","D","S"]

    def initialize( stringCombination )
        initialize_validations( stringCombination )
    end

    def self.allValidNumbers
        return VALID_NUMBERS + VALID_LETTER_NUMBERS
    end

    def ==( value)
        return false if not value.is_a?( Card )
        return false if value.number != @number
        return false if value.suit != @suit
        return true
    end

    private 

    def errorMessageBase
        message = "Tried to create a card passing"
    end

    def initialize_validations( stringCombination )        
        raise "#{errorMessageBase} a non-String as parameter: #{stringCombination}" if not stringCombination.is_a?(String)
        raise "#{errorMessageBase} a String with a number of characters different of 2: #{stringCombination}" if stringCombination.size != 2
        firstChar = stringCombination[0]
        validateNumber( firstChar )
        secondChar = stringCombination[1]
        validateSuit( secondChar )  
    end

    def validateNumber( value )
        cardNumber = value.upcase
        validNumber = Card.allValidNumbers.include?( cardNumber )
        raise "#{errorMessageBase} a invalid numerical value: #{value}" if not validNumber
        @number = cardNumber
    end

    def validateSuit( value )
        cardSuit = value.upcase
        validSuit = Card::VALID_SUITS.include?( cardSuit )
        raise "#{errorMessageBase} a invalid suit value: #{value}" if not validSuit
        @suit = cardSuit
    end
end