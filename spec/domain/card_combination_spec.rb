require_relative "../../app/domain/card.rb"
require_relative "../../app/domain/card_combination.rb"
require_relative "../../app/services/game_service.rb"

gameService = GameService.new

def assert( actual, expected )
    expect( expected ).to eq( actual )
end

def createArrayOfCardsFromNumbersAndSuit( numbersSequence, suit )
    cards = []
    for number in numbersSequence
        letter = Card.numberAsLetter( number )
        if letter
            number = letter
        end
        cards << Card.create( number, suit )
    end
    return cards
end

def createArrayOfCardsFromNumbersAllSuit( numbersSequence )
    cards = []
    for suit in Card::VALID_SUITS
        cards << createArrayOfCardsFromNumbersAndSuit( numbersSequence, suit )
    end
    return cards
end

def createArrayOfCardsAllNumericalSequencesAllSuit( )
    cards = []
    for number in 1..13                
        range = number..(number+4)
        array = createArrayOfCardsFromNumbersAllSuit( range )
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
            assert( bestMove, CardCombination::ROYAL_STRAIGHT_FLUSH )
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