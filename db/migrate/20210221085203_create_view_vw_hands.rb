class CreateViewVwHands < ActiveRecord::Migration[6.1]
    def up
        execute <<-SQL
            CREATE VIEW vw_hands
            AS
            select ch.hand_id, GROUP_CONCAT( c.number||'-'||s.name, "," ) as cards
            from cards_hands ch
                inner join cards c on c.id = ch.card_id    
                inner join suits s on c.suit_id = s.id
            group by ch.hand_id
            ;  
        SQL
    end

    def down
        execute <<-SQL
            DROP VIEW IF EXISTS vw_hands;
        SQL
    end
end
