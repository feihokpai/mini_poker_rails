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
            firstCardIs10 = hand.first.numberAsInteger == Card::TEN_VALUE
            lastCardIs1 = hand.last.numberAsInteger == Card::ACE_VALUE
            if firstCardIs10 && lastCardIs1
                next
            end
            bestMove = CardCombination.move( hand )
            verify( bestMove, CardCombination::STRAIGHT_FLUSH, hand )
        end
    end

    it 'move() - Flush' do
        arrayOfHands = []
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [1,2,3,4,6] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [1,2,3,4,7] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [1,2,3,4,8] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [1,3,4,8,10] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [1,3,8,10,13] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [8,9,10,11,13] )
        arrayOfHands += createArrayOfCardsFromNumbersAllSuit( [11,12,13,14,3] )
        for hand in arrayOfHands
            bestMove = CardCombination.move( hand )
            verify( bestMove, CardCombination::FLUSH, hand )
        end
    end
end