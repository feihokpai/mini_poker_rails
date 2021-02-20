require_relative "../../app/domain/card.rb"
require_relative "../../app/domain/card_combination.rb"
require_relative "../../app/services/game_service.rb"

gameService = GameService.new


def verify( actual, expected, handTested="" )
    expect( expected ).to eq( actual )    
end

def notPassed( )
    verify( true, false)
end

def passed()
    verify( true, true)
end


def createArrayOfCardsFromNumbersAndSuit( numbersArray, suit )
    cards = []
    for number in numbersArray
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
    maximumValue = 14
    for number in 1..(maximumValue-4)                
        rangeArray = (number..(number+4)).to_a()
        array = createArrayOfCardsFromNumbersAllSuit( rangeArray )
        cards = cards + array
    end
    return cards
end

describe CardCombination do

    it 'move() - Verifying of repeated cards in a hand or deck' do
        cardsSequences = []
        cardsSequences << 'AD AH AS 2C AD'
        cardsSequences << '3D 3H 3S 5D 5D'
        cardsSequences << '6D 6H 6S 8C 6D'
        cardsSequences << 'TD TH TD JC JD'
        cardsSequences << 'JD JH JH QC QD'
        cardsSequences << 'QD QH QS QH KD'
        cardsSequences << 'KD KH KS AC AC'
        cardsSequences << 'KH KH KS AC AD'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            begin
                bestMove = CardCombination.move( arrayOfCards )
                puts "Should throw an exception, but not did. Verifying: #{arrayOfCards}"
                notPassed()
            rescue ArgumentError => ex                
            end
        end
    end

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

    it 'move() - Four of a kind' do
        cardsSequences = []
        cardsSequences << 'AD AH AS AC 2D'
        cardsSequences << '3D 3H 3S 3C 2D'
        cardsSequences << '6D 6H 6S 6C 2D'
        cardsSequences << 'TD TH TS TC 2D'
        cardsSequences << 'JD JH JS JC 2D'
        cardsSequences << 'QD QH QS QC 2D'
        cardsSequences << 'KD KH KS KC 2D'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::FOUR_OF_A_KIND, hand )
        end
    end

    it 'move() - Full House' do
        cardsSequences = []
        cardsSequences << 'AD AH AS 2C 2D'
        cardsSequences << '3D 3H 3S 5C 5D'
        cardsSequences << '6D 6H 6S 8C 8D'
        cardsSequences << 'TD TH TS JC JD'
        cardsSequences << 'JD JH JS QC QD'
        cardsSequences << 'QD QH QS KC KD'
        cardsSequences << 'KD KH KS AC AD'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::FULL_HOUSE, hand )
        end
    end

    it 'move() - Straight' do
        cardsSequences = []
        cardsSequences << 'AD 2H 3S 4C 5D'
        cardsSequences << '2D 3H 4S 5C 6D'
        cardsSequences << '3D 4H 5S 6C 7D'
        cardsSequences << '5H 6H 7H 8H 9D'
        cardsSequences << '6D 7H 8S 9C TD'
        cardsSequences << 'TD JH QS KC AD'        
        
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::STRAIGHT, hand )
        end
    end

    it 'move() - Three of a kind' do
        cardsSequences = []
        cardsSequences << 'AD AH AS 3C 2D'
        cardsSequences << '3D 3H 3S 4C 2D'
        cardsSequences << '6D 6H 6S 7C 2D'
        cardsSequences << 'TD TH TS AC 2D'
        cardsSequences << 'JD JH JS AC 2D'
        cardsSequences << 'QD QH QS KC 2D'
        cardsSequences << 'KD KH KS AC 2D'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::THREE_OF_A_KIND, hand )
        end
    end


    it 'move() - Two pairs' do
        cardsSequences = []
        cardsSequences << 'AD AH 3S 3C 2D'
        cardsSequences << '3D 3H 4S 4C 2D'
        cardsSequences << '6D 6H 2S 7C 2D'
        cardsSequences << 'TD TH 2S AC 2D'
        cardsSequences << 'JD JH AS AC 2D'
        cardsSequences << 'QD QH 2S KC 2D'
        cardsSequences << 'KD KH AS AC 2D'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::TWO_PAIRS, hand )
        end
    end

    it 'move() - One pair' do
        cardsSequences = []
        cardsSequences << 'AD AH 5S 3C 2D'
        cardsSequences << '3D 3H 6S 4C 2D'
        cardsSequences << '6D 6H 8S 7C 2D'
        cardsSequences << 'TD TH 3S AC 2D'
        cardsSequences << 'JD JH KS AC 2D'
        cardsSequences << 'QD QH AS KC 2D'
        cardsSequences << 'KD KH 3S AC 2D'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::ONE_PAIR, hand )
        end
    end

    it 'move() - Highest Card' do
        cardsSequences = []
        cardsSequences << 'AD 6H 5S 3C 2D'
        cardsSequences << '3D 9H 6S 4C 2D'
        cardsSequences << '6D AH 8S 7C 2D'
        cardsSequences << 'TD QH 3S AC 2D'
        cardsSequences << 'JD 4H KS AC 2D'
        cardsSequences << 'QD 3H AS KC 2D'
        cardsSequences << 'KD 5H 3S AC 2D'
        cardsSequences << 'JD QH KS AC 2D'
        cardsSequences << 'QH KS AC 2D 3D'
        cardsSequences << 'KS AC 2D 3D 4S'
        for hand in cardsSequences
            arrayOfCards = gameService.convertCardCodesStringOnCardsArray( hand )
            bestMove = CardCombination.move( arrayOfCards )
            verify( bestMove, CardCombination::HIGHEST_CARD, hand )
        end
    end
end