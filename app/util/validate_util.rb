class ValidateUtil
    def self.raiseIfValueIsNotA( value, type, exceptionClass= ArgumentError )
        if not value.is_a?( type )
            message = "It was expected a #{type}, but received a #{value.class}"
            raise exceptionClass.new( message )
        end
    end
end