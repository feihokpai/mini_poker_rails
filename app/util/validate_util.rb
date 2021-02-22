class ValidateUtil
    def self.raiseIfValueIsNotA( value, type, exceptionClass= ArgumentError )
        if not value.is_a?( type )
            message = "It was expected a #{type}, but received a #{value.class}"
            raise exceptionClass.new( message )
        end
    end

    def self.raiseIfValueIsNotABoolean( value, exceptionClass= ArgumentError )
        if not( [true, false].include?( x ) )
            message = "It was expected a Boolean type, but received a #{value.class}"
            raise exceptionClass.new( message )
        end
    end

    def self.raiseIfIsNotAnArrayWithOnly( array, className, exceptionClass= ArgumentError )
        allTypes = ArrayUtil.differentTypesInArray( array )
        if allTypes.size > 1
            undesiredTypes = allTypes - [className]
            message = "It was expected an array with only #{className}, but it was also found #{undesiredTypes}"
            raise exceptionClass.new( message )
        end
    end

    def self.raiseIfArrayHasADifferentSize( array, size, exceptionClass= ArgumentError )
        ValidateUtil.raiseIfValueIsNotA( array, Array )
        ValidateUtil.raiseIfValueIsNotA( size, Integer )
        if array.size != size
            message = "It was expected an array with exactly #{size} values, but it was also found #{array.size}"
            raise exceptionClass.new( message )
        end
    end

    def self.raiseIfNotAllValuesInArrayAreUnique( array, exceptionClass= ArgumentError )
        duplicates = ArrayUtil.duplicateValues( array )
        if duplicates.size > 0            
            message = "It's was epected an array with only unique values, but was found duplicates: #{duplicates}"
            raise exceptionClass.new( message )
        end
    end
    
end