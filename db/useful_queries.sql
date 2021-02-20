-- Get the list of all cards
select c.id, ( c.number||'-'||s.name ) card
from cards c
    inner join suits s on s.id = c.suit_id
;