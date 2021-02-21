class ArrayUtil
    def self.duplicateValues( array )
        return array.select{|element| array.count(element) > 1 }
    end

    def self.allValuesAreUnique?( array )
        duplicates = ArrayUtil.duplicateValues( array )
        return duplicates.empty?
    end

    def self.changeValue( array, before, after )
        newArray = array.map {|item| (item==before ? after : item) }
        return newArray
    end

    def self.convertToArrayOfIntegers( array )
        newArray = []
        for item in array
            begin
                newArray << item.to_i()
            rescue
                raise ArgumentError.new( "Failed to convert this value in Integer: #{item}" )
            end
        end
        return newArray
    end

    def self.isAnArrayWithAllValuesAsIntegersInSequence?( array )
        return false if not isAnArrayWithOnly?( array, Integer )
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

    def self.differentTypesInArray( array )
        ValidateUtil.raiseIfValueIsNotA( array, Array )
        return [] if array.empty?       
        classesInArray = array.map { |item| item.class }
        return classesInArray.uniq()
    end
end