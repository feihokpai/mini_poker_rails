class Card
    attr_reader :number, :suit

    VALID_NUMERICAL_NUMBERS = ('1'..'9').to_a()
    VALID_LETTER_NUMBERS = ["A","T","J","Q","K"]
    VALID_NUMBERS = VALID_NUMERICAL_NUMBERS + VALID_LETTER_NUMBERS
    VALID_SUITS = ["C","H","D","S"]

    def initialize( stringCombination )
        initialize_validations( stringCombination )
    end

    def ==( value)
        return false if not value.is_a?( Card )
        return false if value.number != @number
        return false if value.suit != @suit
        return true
    end

    private 

    def argumentErrorMessageBase        
        message = "Tried to create a card passing"
    end

    def argumentError( message )
        raise ArgumentError.new( "#{argumentErrorMessageBase} #{message}" )        
    end

    def initialize_validations( stringCombination ) 
        argumentError( "a non-String as parameter: #{stringCombination}" ) if not stringCombination.is_a?(String)  
        msgAboutNumberOfCharacters = "a String with a number of characters different of 2: #{stringCombination}"
        argumentError( msgAboutNumberOfCharacters ) if stringCombination.size != 2
        firstChar = stringCombination[0]
        validateNumber( firstChar )
        secondChar = stringCombination[1]
        validateSuit( secondChar )  
    end

    def validateNumber( value )
        cardNumber = value.upcase
        validNumber = Card::VALID_NUMBERS.include?( cardNumber )
        argumentError( "a invalid numerical value: #{value}" ) if not validNumber        
        @number = cardNumber
    end

    def validateSuit( value )
        cardSuit = value.upcase
        validSuit = Card::VALID_SUITS.include?( cardSuit )
        argumentError( "a invalid suit value: #{value}" ) if not validSuit        
        @suit = cardSuit
    end
end