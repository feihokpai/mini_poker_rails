class CreateJoinTableCardHand < ActiveRecord::Migration[6.1]
  def change
    create_join_table :cards, :hands do |t|
      # t.index [:card_id, :hand_id]
      # t.index [:hand_id, :card_id]
    end
  end
end
