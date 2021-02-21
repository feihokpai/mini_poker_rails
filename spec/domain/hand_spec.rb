require_relative "../../app/domain/card.rb"
require_relative "../../app/domain/hand.rb"
require_relative "../../app/domain/domain_object.rb"
require_relative "../../app/services/dao_interface.rb"
require_relative "../../app/services/game_service.rb"

gameService = GameService.new

describe Hand do
    it 'move() - Verifying of repeated cards in a hand' do
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
                Card.new( arrayOfCards )
                puts "Should throw an exception, but not did. Verifying: #{arrayOfCards}"
                notPassed()
            rescue ArgumentError => ex                
            end
        end
    end
end