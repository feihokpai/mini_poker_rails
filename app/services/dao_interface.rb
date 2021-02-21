class DaoInterface
    def save( domainObject )
        raiseNotImpplemented()
    end

    private

    def raiseNotImpplemented()
        raise "You are trying to call a method inherited from a interface, but not implemented"
    end
end