class Card < DomainObject
    attr_reader :number, :suit

    VALID_NUMERICAL_NUMBERS = ('2'..'9').to_a()
    VALID_LETTER_NUMBERS = ["A","T","J","Q","K"]
    VALID_LETTER_NUMBERS_FROM_10 = ["T","J","Q","K"]
    VALID_NUMBERS = VALID_NUMERICAL_NUMBERS + VALID_LETTER_NUMBERS
    VALID_SUITS = ["C","H","D","S"]
    
    ACE_VALUE=1
    TEN_VALUE=10
    JACK_VALUE=11
    QUEEN_VALUE=12
    KING_VALUE=13
    TEN_TO_KING_VALUES = [10,11,12,13]
    TWO_TO_NINE_VALUES = [2,3,4,5,6,7,8,9]
    AFTER_KING_VALUES = [14]

    ACE_PLUS_KING_VALUE=14

    def initialize( stringCombination )
        initialize_validations( stringCombination )
    end

    def self.create( number, suit)
        newNumber = number
        if (number == ACE_VALUE or number == ACE_PLUS_KING_VALUE)
            newNumber = "A"   
        elsif TEN_TO_KING_VALUES.include?(number )
            newNumber = numberAsLetter( number )
        elsif not( TWO_TO_NINE_VALUES.include?(number) )
            raise ArgumentError.new( "Invalid numerical value to a card: #{number}" )
        end        
        return Card.new( "#{newNumber}#{suit}" )
    end

    def ==( value)
        return false if not value.is_a?( Card )
        return false if value.number != @number
        return false if value.suit != @suit
        return true
    end

    def self.isArrayOfCards( object )
        return ArrayUtil.isAnArrayWithOnly?( object, Card )
    end

    def numberAsInteger
        isNumericalValueInteger = StringUtil.isInteger?( @number )
        return number.to_i() if isNumericalValueInteger
        return ACE_VALUE if @number == "A"
        return TEN_VALUE if @number == "T"
        return JACK_VALUE if @number == "J"
        return QUEEN_VALUE if @number == "Q"
        return KING_VALUE if @number == "K"
    end

    def self.numberAsLetter( number )
        return "A" if (number == ACE_VALUE or number == ACE_PLUS_KING_VALUE)
        return "T" if number == TEN_VALUE
        return "J" if number == JACK_VALUE
        return "Q" if number == QUEEN_VALUE
        return "K" if number == KING_VALUE
        return nil
    end

    def stringDefinition
        return "#{number}#{suit}"
    end

    def self.convertCardsArrayToString( cardsArray )   
        self.validate_convertCardsArrayOnCardCodesString( cardsArray )           
        allCodeCards = cardsArray.map { |card| card.stringDefinition }
        codeCardsString = allCodeCards.join( " " )
        return codeCardsString
    end

    def self.convertCardCodesStringToCardsArray( cardCodesString )
        ValidateUtil.raiseIfValueIsNotA(cardCodesString, String )
        codeCardsArray = cardCodesString.split(" ")
        cardsArray = []
        for codeCard in codeCardsArray
            cardsArray << Card.new( codeCard )            
        end
        return cardsArray
    end

    def to_s()
        return "Card(number=#{number},suit=#{suit})"
    end

    def to_str
        return to_s
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

    def self.validate_convertCardsArrayOnCardCodesString( cardsArray )
        ValidateUtil.raiseIfIsNotAnArrayWithOnly( cardsArray, Card )
    end
end