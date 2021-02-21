class CreateViewVwMoves < ActiveRecord::Migration[6.1]
    def up
      execute <<-SQL
        
        CREATE VIEW IF NOT EXISTS vw_moves
        AS
        select m.id as move_id, ini.cards as initial_cards, deck.cards as deck_cards, best.cards as best_move_cards
        from moves m
            inner join vw_hands ini on ini.hand_id = m.initial_hand_id
            inner join vw_hands deck on deck.hand_id = m.deck_hand_id
            inner join vw_hands best on best.hand_id = m.best_hand_id
        ;
      SQL
    end

    def down
      execute <<-SQL
        DROP VIEW IF EXISTS vw_moves;
      SQL
    end
end
