class DaoInterface

    attr_reader :transactionActived

    def save( domainObject, transactionActived=false )
        raiseNotImpplemented()
    end

    private

    def raiseNotImpplemented()
        raise "You are trying to call a method inherited from a interface, but not implemented"
    end
end