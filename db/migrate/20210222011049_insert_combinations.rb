class InsertCombinations < ActiveRecord::Migration[6.1]
  def change
    ActiveRecord::Base.transaction do
      CombinationModel.create( id: 1, code: "HC", name: "Highest Card" )
      CombinationModel.create( id: 2, code: "OP", name: "One Pair" )
      CombinationModel.create( id: 3, code: "TP", name: "Two Pairs" )
      CombinationModel.create( id: 4, code: "TK", name: "Three of a kind" )
      CombinationModel.create( id: 5, code: "ST", name: "Straight" )
      CombinationModel.create( id: 6, code: "FL", name: "Flush" )
      CombinationModel.create( id: 7, code: "FU", name: "Full House" )
      CombinationModel.create( id: 8, code: "FK", name: "Four of a Kind" )
      CombinationModel.create( id: 9, code: "SF", name: "Straight Flush" )
      CombinationModel.create( id: 10, code: "RS", name: "Royal Straight Flush" )
    end
  end
end
