update product b, assignment a set b.current_owner_id = (select participant_id from assignment a where a.product_id=b.id and action='m' order by ts desc limit 1);
