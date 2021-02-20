require_relative '../services/game_service.rb'
require_relative '../services/invalid_card_code_line_exception.rb'


class GameController < ApplicationController

    def initialize
        @errorMsg = ""
        @lines = []        
        @processedLines = []
        @gameService ||= GameService.new
        super
    end

    def index
    end

    def enter
        @player_name ||= params[:name]
        render :not_started
    end

    def send_file
        begin
            file = createNewFileFromUploadedFile() 
            fileName = File.basename(file)
            jsonResponse = { :message => fileName }            
        rescue StandardError => exception
            printLinesOfBackTrace( exception, 10 )
            @messageToUser = "An Unexpected error ocurred during upload: #{exception.message}"
            jsonResponse = { :message => @messageToUser }
        ensure
            render :json => jsonResponse
        end
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
        rescue InvalidCardCodeLineException => exception            
            @messageToUser = "#{exception.message} - line number: #{lineNumber}."                                    
            @problematicLine = exception.line            
        rescue StandardError => exception
            @messageToUser = "An Unexpected error ocurred: #{exception.message}"
            tenLinesOfBackTrace = exception.backtrace[0..10]
            puts tenLinesOfBackTrace
        ensure
            puts "Problematic line: #{@problematicLine}"
        end
    end

    private

    def printLinesOfBackTrace( exception, numberOfLines )
        lastLine = numberOfLines-1
        linesOfBackTrace = exception.backtrace[0..lastLine]
        puts exception.message()
        puts linesOfBackTrace
    end

    def createNewFileFromUploadedFile()
        contentUserFile = getContentUserFile()        
        newFile =saveContentInNewFile( contentUserFile )
        return newFile
    end

    def saveContentInNewFile( contentUserFile )
        newFile = createNewFileWithTimestampName()
        newFile.puts( contentUserFile )        
        newFile.close()
        return newFile
    end

    def getContentUserFile()
        userFile = params["file"]        
        validateFile( userFile )
        fileContent = userFile.read
        userFile.close()
        return fileContent
    end

    def createNewFileWithTimestampName()
        timestamp = StringUtil.timestampString()
        fileNewName = "upload_#{timestamp}.txt"
        folderPath = getFolderPath()
        filePath = "#{folderPath}#{fileNewName}"
        writeMode = "w"
        newFile = File.new( filePath, writeMode)        
        return newFile
    end

    def getFolderPath()
        return "files/"
    end

    def validateFile( userFile )
        
    end

    def processLine( lineContent )
        allCodeCards = lineContent.split(" ")        
        @gameService.validateLineOfCardCodes( allCodeCards )   
        @cardsArray = @gameService.convertOnCardsArray( allCodeCards )
        bestMove = @gameService.analyzeBestMove( @cardsArray )
        bestMoveDescription = bestMove.nil? ? "Failed" : bestMove.name
        handCards = allCodeCards[0..4]
        stringHandCards = handCards.join(" ")
        first5DeckCards = allCodeCards[5..9]        
        stringFirst5DeckCards = first5DeckCards.join(" ")
        textToUser = "Hand: #{stringHandCards} Deck: #{stringFirst5DeckCards} - Best game: #{bestMoveDescription}"
        return textToUser
    end

end
