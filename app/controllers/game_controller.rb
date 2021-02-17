class GameController < ApplicationController

    def initialize
        @errorMsg = ""
        @lines = []        
        @processedLines = []
        super
    end

    def index
    end

    def enter
        @player_name ||= params[:name]
        render :not_started
    end

    def process_file
        @fileContent = File.read("files/text.txt")
        @lines = @fileContent.split("\n")
        lineNumber = 0
        @problematicLine = ""
        begin
            for line in @lines
                # @problematicLine = line
                lineNumber += 1
                @processedLines << processLine( line )
            end
            @problematicLine = ""
        rescue ArgumentError => exception            
            @messageToUser = "The file validation has been failed on reading the line #{lineNumber}. Reason: #{exception.message}"            
        rescue StandardError => exception
            @messageToUser = "An Unexpected error ocurred: #{exception.message}"
        end

        @porra = "Vai se lascar: #{@messageToUser}"
    end

    private

    def processLine( lineContent )
        validateLine( lineContent )
        allCards = lineContent.split(" ")
        handCards = allCards[0..4]
        stringHandCards = handCards.join(" ")
        first5DeckCards = allCards[5..9]        
        stringFirst5DeckCards = first5DeckCards.join(" ")
        textToUser = "Hand: #{stringHandCards} Deck: #{stringFirst5DeckCards} - Best game:"
        return textToUser
    end

    def validateLine( lineContent )
        allCodeCards = lineContent.split(" ")
        for codeCard in allCodeCards
            begin
                Card.new( codeCard )
            rescue ArgumentError => exception                
                positionOfProblematicValueInArray = allCodeCards.find_index( codeCard )
                allCodeCards[ positionOfProblematicValueInArray ] = "|#{codeCard}|"
                # allCodeCards.insert( (1+positionOfProblematicValueInArray), "|" )
                # allCodeCards.insert( positionOfProblematicValueInArray, "|" )
                @problematicLine = allCodeCards.join(" ")
                puts "Exception Catched. Generated: #{@problematicLine}"
                raise
            end
        end
    end
end
