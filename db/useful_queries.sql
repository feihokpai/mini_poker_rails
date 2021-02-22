-- Get the list of all cards
select c.id, ( c.number||'-'||s.name ) card
from cards c
    inner join suits s on s.id = c.suit_id
;


DROP VIEW IF EXISTS vw_hands;
CREATE VIEW vw_hands
AS
select ch.hand_id, GROUP_CONCAT( c.number||'-'||s.name, "," ) as cards
from cards_hands ch
    inner join cards c on c.id = ch.card_id    
    inner join suits s on c.suit_id = s.id
group by ch.hand_id
;    


DROP VIEW IF EXISTS vw_hands;
CREATE VIEW vw_hands
AS
select ch.hand_id
    , GROUP_CONCAT( c.number|| SUBSTR(s.name, 1,1), "," ) as cards
from cards_hands ch
    inner join cards c on c.id = ch.card_id    
    inner join suits s on c.suit_id = s.id
group by ch.hand_id
;    

DROP VIEW IF EXISTS vw_moves;
CREATE VIEW vw_moves
AS
select m.id as move_id, ini.cards as initial_cards, deck.cards as deck_cards, best.cards as best_move_cards
from moves m
    inner join vw_hands ini on ini.hand_id = m.initial_hand_id
    inner join vw_hands deck on deck.hand_id = m.deck_hand_id
    inner join vw_hands best on best.hand_id = m.best_hand_id
;

DROP VIEW IF EXISTS vw_moves;
CREATE VIEW vw_moves
AS
select m.id as move_id, (c.id||'-'||c.name) as combination, ini.cards as initial_cards
    , deck.cards as deck_cards, best.cards as best_move_cards
from moves m
    inner join vw_hands ini on ini.hand_id = m.initial_hand_id
    inner join vw_hands deck on deck.hand_id = m.deck_hand_id
    inner join vw_hands best on best.hand_id = m.best_hand_id
    inner join combinations c on c.id = m.combination_id
;

