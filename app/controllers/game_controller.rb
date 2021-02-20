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
            jsonResponse = { :message => fileName, :success => 1 }            
        rescue StandardError => exception
            printLinesOfBackTrace( exception, 10 )
            @messageToUser = "An Unexpected error ocurred during upload: #{exception.message}"
            jsonResponse = { :message => @messageToUser, :success => 0 }
        ensure
            render :json => jsonResponse
        end
    end    

    def process_file
        begin
            fileName = params["file_name"]
            if not( fileName.present? )
                raise "The processing failed, because no file was sent."
            end
            pathFile = "#{getFolderPath}#{fileName}"
            @fileContent = File.read( pathFile )
            @lines = @fileContent.split("\n")
            lineNumber = 0
            @problematicLine = ""
        
            for line in @lines
                lineNumber += 1
                @processedLines << processLine( line )
            end
        rescue InvalidCardCodeLineException => exception            
            @messageToUser = "#{exception.message} - line number: #{lineNumber}."                                    
            @problematicLine = exception.line            
        rescue StandardError => exception
            @messageToUser = "An Unexpected error ocurred: #{exception.message}"
            printLinesOfBackTrace( exception, 10 )
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
        extNameWithPoint = File.extname( userFile )
        extension = extNameWithPoint[1..-1]
        if (extension != "txt" && extension != "TXT")
            raise "It was uploaded a file with invalid extension: '#{extNameWithPoint}'. Allowed: '.txt'"
        end
    end

    def processLine( lineContent )
        allCodeCards = lineContent.split(" ")        
        @gameService.validateLineOfCardCodes( allCodeCards )   
        @cardsArray = @gameService.convertOnCardsArray( allCodeCards )
        bestResult = @gameService.analyzeBestMove( @cardsArray )
        bestMoveDescription = bestResult.nil? ? "Failed" : bestResult[:combination].name
        handCards = allCodeCards[0..4]
        stringHandCards = handCards.join(" ")
        first5DeckCards = allCodeCards[5..9]        
        stringFirst5DeckCards = first5DeckCards.join(" ")
        textToUser = "Hand: #{stringHandCards} Deck: #{stringFirst5DeckCards} - Best combination: #{bestMoveDescription}"
        bestMoveString = Card.convertCardsArrayToString( bestResult[:move] )
        textToUser += " - (#{bestMoveString})"
        return textToUser
    end

end
