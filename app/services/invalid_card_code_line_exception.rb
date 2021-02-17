class InvalidCardCodeLineException < StandardError
    attr_reader :line

    def initialize( problematicLine )
        @line = problematicLine
        super
    end

    def message
        return "Validation of a line with card codes has been failed"
    end
end