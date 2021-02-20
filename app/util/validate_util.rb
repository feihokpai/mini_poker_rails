class ValidateUtil
    def self.raiseIfValueIsNotA( value, type, exceptionClass= ArgumentError )
        if not value.is_a?( type )
            message = "It was expected a #{type}, but received a #{value.class}"
            raise exceptionClass.new( message )
        end
    end

    def self.raiseIfIsNotAnArrayWithOnly( array, className, exceptionClass= ArgumentError )
        allTypes = ValidateUtil.differentTypesInArray( array )
        if allTypes.size > 1
            undesiredTypes = allTypes - [className]
            message = "It was expected an array with only #{className}, but it was also found #{undesiredTypes}"
            raise exceptionClass.new( message )
        end
    end

    def self.differentTypesInArray( array )
        self.raiseIfValueIsNotA( array, Array )
        return [] if array.empty?       
        classesInArray = array.map { |item| item.class }
        return classesInArray.uniq()
    end
end