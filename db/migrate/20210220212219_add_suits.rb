class AddSuits < ActiveRecord::Migration[6.1]
  def change
    SuitModel.create( id: 1, name: "Heart", letter: "H" )
    SuitModel.create( id: 2, name: "Diamond", letter: "D" )
    SuitModel.create( id: 3, name: "Club", letter: "C" )
    SuitModel.create( id: 4, name: "Sword", letter: "S" )
  end
end
