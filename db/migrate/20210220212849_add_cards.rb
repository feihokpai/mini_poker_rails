class AddCards < ActiveRecord::Migration[6.1]
  def change
    swordSuit = SuitModel.where( letter: "S" ).first
    heartSuit = SuitModel.where( letter: "H" ).first
    clubSuit = SuitModel.where( letter: "C" ).first 
    diamondSuit = SuitModel.where( letter: "D" ).first 
    for numerical in 1..13
      CardModel.create( number: numerical, suit: swordSuit )
      CardModel.create( number: numerical, suit: heartSuit )
      CardModel.create( number: numerical, suit: clubSuit )
      CardModel.create( number: numerical, suit: diamondSuit ) 
    end
  end
end
