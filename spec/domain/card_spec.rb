require_relative "../../app/domain/card.rb"

def notPassedWithMessage( msg )
    puts "msg: #{msg}" 
    expect( true ).to eq( false )
end

def notPassed( )
    expect( true ).to eq( false )
end

def passed()
    expect( true ).to eq( true )
end

def createCard(  number, suit )
    cardString = "#{number}#{suit}"
    Card.new( cardString )
end

def createSpecificCard( number, suit, itShouldPass )
    cardString = "undefined"
    if( !itShouldPass )
        begin
            createCard(number, suit)
            # notPassed()
            notPassedWithMessage( "Testing card #{number}#{suit}")
        rescue
            passed()
        end
    else
        begin
            createCard(number, suit)
        rescue
            fail "Fail on the card creation: '#{number}#{suit}'"
        end
    end

end

def createCards0to9( suit )
    itShouldPass = true
    for number in 1..9
        createSpecificCard( number, suit, itShouldPass )
    end
end

def createLetterCards( suit )
    itShouldPass = true
    for number in ["A","T","J","Q","K"]
        createSpecificCard( number, suit, itShouldPass )
    end
end


describe Card do
    

    it 'Creating cards of 1C to 9C - Club' do
        createCards0to9( "C" )
    end

    it 'Creating letter cards of C - Club' do
        createLetterCards( "C" )
    end

    it "it should't create 0C or 10C card" do
        itShouldPass = false
        createSpecificCard( "10", "C", itShouldPass )
        createSpecificCard( "0", "C", itShouldPass )
    end

    it 'Should convert cards of 1c to 9c to 1C to 9C - Club' do
        itShouldPass = true
        validSmallSuits = ["c","d","h","s"]
        for suit in validSmallSuits
            for number in 1..9
                capitalSuit = suit.upcase
                created = createSpecificCard( number, suit, itShouldPass)
                expected = createSpecificCard( number, capitalSuit, itShouldPass)
                expect( created ).to eq( expected )
            end
        end 
    end

    it 'Creating cards of 1D to 9D - Diamond' do
        createCards0to9( "D" )
    end

    it 'Creating letter cards of D - Diamond' do
        createLetterCards( "D" )
    end

    it "it should't create 0D or 10D card" do
        itShouldPass = false
        createSpecificCard( "10", "D", itShouldPass )
        createSpecificCard( "0", "D", itShouldPass )
    end

    # it 'Should convert cards of 1d to 9d to 1D to 9D - Club' do
    #     itShouldPass = true
    #     for number in 1..9
    #         created = createSpecificCard( number, "d", itShouldPass)
    #         expected = createSpecificCard( number, "D", itShouldPass)
    #         expect( created ).to eq( expected )
    #     end
    # end

    it 'Creating cards of 1S to 9S - Sword' do
        createCards0to9( "S" )
    end

    it 'Creating letter cards of S - Sword' do
        createLetterCards( "S" )
    end

    it "it should't create 0S or 10S card" do
        itShouldPass = false
        createSpecificCard( "10", "S", itShouldPass )
        createSpecificCard( "0", "S", itShouldPass )
    end

    # it 'Should convert cards of 1s to 9s to 1S to 9S - Club' do
    #     itShouldPass = true
    #     for number in 1..9
    #         created = Card.new( number, "s")
    #         expected = Card.new( number, "S")
    #         expect( created ).to eq( expected )
    #     end
    # end

    it 'Creating cards of 1H to 9H - Hearts' do
        createCards0to9( "H" )
    end

    it 'Creating letter cards of H - Hearts' do
        createLetterCards( "H" )
    end

    it "it should't create 0H or 10H card" do
        itShouldPass = false
        createSpecificCard( "10", "H", itShouldPass )
        createSpecificCard( "0", "H", itShouldPass )
    end

    # it 'Should convert cards of 1h to 9h to 1H to 9H - Club' do
    #     for number in 1..9
    #         created = Card.new( number, "h")
    #         expected = Card.new( number, "H")
    #         expect( created ).to eq( expected )
    #     end
    # end

    it "Shouldn't create cards of 1h to 11 to 99" do
        itShouldPass = false                
        for number in 11..99
            suit = "C"
            createSpecificCard( number, suit, itShouldPass )
        end
    end

    it "Shouldn't create cards with numbers with invalid Capital letter " do
        itShouldPass = false
        allCapitalLetters = ('A'..'Z').to_a
        validLetters = ["A","T","J","Q","K"]
        invalidCapitalletters = allCapitalLetters - validLetters
        for number in invalidCapitalletters
            for suit in Card::VALID_SUITS
                createSpecificCard( number, suit, itShouldPass )
            end 
        end
    end

    it "Shouldn't create cards numbers with invalid Small letter " do
        itShouldPass = false
        allSmallLetters = ('a'..'z').to_a
        validSmallLetters = ["a","t","j","q","k"]
        invalidSmallletters = allSmallLetters - validSmallLetters
        for number in invalidSmallletters
            for suit in Card::VALID_SUITS
                createSpecificCard( number, suit, itShouldPass )
            end 
        end
    end

    it "Shouldn't create cards with suit with invalid Capital letter " do
        itShouldPass = false
        allCapitalLetters = ('A'..'Z').to_a
        invalidCapitalletters = allCapitalLetters - Card::VALID_SUITS
        for suit in invalidCapitalletters
            for number in Card::VALID_NUMBERS
                createSpecificCard( number, suit, itShouldPass )
            end 
        end
    end

    it "Shouldn't create cards with suit with invalid Small letter " do
        itShouldPass = false
        allCapitalLetters = ('a'..'z').to_a
        smallValidSuits = Card::VALID_SUITS.map { |value| value.downcase }
        invalidCapitalletters = allCapitalLetters - smallValidSuits
        for suit in invalidCapitalletters
            for number in Card::VALID_NUMBERS
                createSpecificCard( number, suit, itShouldPass )
            end 
        end
    end

    it "Shouldn't create cards with invalid characters" do
        itShouldPass = false
        invalidCharacters = ["'"," ","!","@","#","$","%","¨","&","*","(",")","-","_","=","+","[","{","]","}","/","?",";",":",".",">",",","<","|","\\"]
        for suit in invalidCharacters
            number = 1
            createSpecificCard( number, suit, itShouldPass )
        end
    end

    it 'Should convert cards of aH,jH to AH,Jh' do
        itShouldPass = true
        lettersNumbers = ["a","t","j","q","k"]
        suits = Card::VALID_SUITS
        for number in lettersNumbers
            for suit in suits
                capitalSuit = suit.upcase
                created = createSpecificCard( number, suit, itShouldPass )
                expected = createSpecificCard( number, capitalSuit, itShouldPass )
                expect( created ).to eq( expected )
            end
        end
    end
end