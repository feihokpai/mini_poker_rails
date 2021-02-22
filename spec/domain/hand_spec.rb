require_relative "../../app/domain/card.rb"
require_relative "../../app/domain/hand.rb"
require_relative "../../app/domain/domain_object.rb"
# require_relative "../../app/util/validate_util.rb"

describe Hand do
    it 'new() - Verifying of repeated cards in a hand' do
        cardsSequences = []
        cardsSequences << 'AD AH AS 2C AD'
        cardsSequences << '3D 3H 3S 5D 5D'
        cardsSequences << '6D 6H 6S 8C 6D'
        cardsSequences << 'TD TH TD JC JD'
        cardsSequences << 'JD JH JH QC QD'
        cardsSequences << 'QD QH QS QH KD'
        cardsSequences << 'KD KH KS AC AC'
        cardsSequences << 'KH KH KS AC AD'
        for codesString in cardsSequences
            cardsArray = Card.convertCardCodesStringToCardsArray( codesString )
            begin
                Hand.new( cardsArray )
                puts "Should throw an exception, but not did. Verifying: #{codesString}"
                notPassed()
            rescue ArgumentError => ex                
            end
        end
    end

    it 'new() - Trying to create a hand with less or more than 5 cards' do
        cardsSequences = []
        cardsSequences << 'AD'
        cardsSequences << '3D 3H'
        cardsSequences << '6D 6H 6S'
        cardsSequences << 'TD TH TD JC'
        cardsSequences << 'JD JH JH QC QD QH'
        cardsSequences << 'QD QH QS QH KD KH JH'
        for codesString in cardsSequences
            cardsArray = Card.convertCardCodesStringToCardsArray( codesString )
            begin
                Hand.new( cardsArray )
                puts "Should throw an exception, but not did. Verifying: #{codesString}"
                notPassed()
            rescue ArgumentError => ex   
                # puts ex.message             
            end
        end
    end

    it 'create() - Verifying of repeated cards in a hand' do
        cardsSequences = []
        cardsSequences << 'AD AH AS 2C AD'
        cardsSequences << '3D 3H 3S 5D 5D'
        cardsSequences << '6D 6H 6S 8C 6D'
        cardsSequences << 'TD TH TD JC JD'
        cardsSequences << 'JD JH JH QC QD'
        cardsSequences << 'QD QH QS QH KD'
        cardsSequences << 'KD KH KS AC AC'
        cardsSequences << 'KH KH KS AC AD'
        for codesString in cardsSequences
            begin
                Hand.create( codesString )
                puts "Should throw an exception, but not did. Verifying: #{codesString}"
                notPassed()
            rescue ArgumentError => ex                
            end
        end
    end

    it 'create() - Trying to create a hand with less or more than 5 cards' do
        cardsSequences = []
        cardsSequences << 'AD'
        cardsSequences << '3D 3H'
        cardsSequences << '6D 6H 6S'
        cardsSequences << 'TD TH TD JC'
        cardsSequences << 'JD JH JH QC QD QH'
        cardsSequences << 'QD QH QS QH KD KH JH'
        for codesString in cardsSequences
            begin
                Hand.create( codesString )
                puts "Should throw an exception, but not did. Verifying: #{codesString}"
                notPassed()
            rescue ArgumentError => ex   
                # puts ex.message             
            end
        end
    end
end