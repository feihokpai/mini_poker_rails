require_relative "../../app/domain/card.rb"
require_relative "../../app/domain/card_combination.rb"
require_relative "../../app/services/game_service.rb"

gameService = GameService.new

def verify( actual, expected, handTested="" )
    expect( expected ).to eq( actual )    
end

def createArrayOfCardsFromNumbersAndSuit( numbersArray, suit )
    cards = []
    for number in numbersArray
        letter = Card.numberAsLetter( number )
        if letter
            number = letter
        end
        cards << Card.create( number, suit )
    end
    return cards
end

def createArrayOfCardsFromNumbersAllSuit( numbersArray )
    cards = []
    for suit in Card::VALID_SUITS
        cards << createArrayOfCardsFromNumbersAndSuit( numbersArray, suit )
    end
    return cards
end

def createArrayOfCardsAllNumericalSequencesAllSuit( )
    cards = []
    for number in 1..13                
        rangeArray = (number..(number+4)).to_a()
        array = createArrayOfCardsFromNumbersAllSuit( rangeArray )
        cards = cards + array
    end
    return cards
end

describe CardCombination do
    it 'move() - Royal Straight Flush' do
        cardsSequences = []
        cardsSequences << 'TD JD QD KD AD'
        cardsSequences << 'TS JS QS KS AS'
        cardsSequences << 'TC JC QC KC AC'
        cardsSequences << 'TH JH QH KH AH'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::ROYAL_STRAIGHT_FLUSH, hand )
        end
    end

    it 'move() - Straight Flush' do
        arrayOfHandsWithCards = createArrayOfCardsAllNumericalSequencesAllSuit()        
        for hand in arrayOfHandsWithCards
            bestMove = CardCombination.move( hand )
            assert( bestMove, CardCombination::STRAIGHT_FLUSH )
        end
    end
end