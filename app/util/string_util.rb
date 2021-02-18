class StringUtil
    def self.isInteger?( valueString )
        return false if not valueString.is_a?(String)
        return valueString.to_i.to_s == valueString
    end
end