class InvalidCardCodeLineException < StandardError
    attr_reader :line, :specificMessage

    def initialize( problematicLine, message = "" )
        @line = problematicLine
        @specificMessage = message
        super()
    end

    def message
        return "Validation of a line with card codes has been failed: #{specificMessage}"
    end
end