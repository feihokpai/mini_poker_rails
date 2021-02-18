class ArrayUtil
    def self.duplicateValues( array )
        duplicates = array.select{|element| array.count(element) > 1 }
        return duplicates
    end

    def self.allValuesInNumericalSequence?( array )
        isNotAnArray = not( array.is_a?( Array ) )
        raise ArgumentError.new( "It was expected an Array, but received a #{array.class}" ) if isNotAnArray
        return false if array.size < 2
        orderedArray = array.sort
        penultimateIndex = orderedArray.size-2
        for index in 0..penultimateIndex
            difference = orderedArray[ index+1 ] - orderedArray[ index ]
            return false if difference != 1
        end
        return true
    end

    def self.isAnArrayWithOnly?( array, className )
        return false if not( array.is_a?( Array ) ) 
        return false if array.empty?       
        for item in array
            return false if not( item.is_a?( className )  )
        end
        return true
    end
end