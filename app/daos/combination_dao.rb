class CombinationDao < DaoInterface
    def save( combinationDomain, transactionActived=false )
        validate_save( combinationDomain )
        if !transactionActived
            @transactionActived = true
            ActiveRecord::Base.transaction do
                return saveCombination( combinationDomain )
            end
        else
            return saveCombination( combinationDomain )
        end   
    end

    private

    def validate_save( combinationDomain )
        ValidateUtil.raiseIfValueIsNotA( combinationDomain, CardCombination )
    end

    def saveCombination( combinationDomain )
        combinationModel = CombinationModel.new( name: combinationDomain.name, code: combinationDomain.code )
        combinationModel.save!()
    end
end