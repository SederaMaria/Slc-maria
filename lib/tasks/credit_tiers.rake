namespace :credit_tiers do
  desc 'Fix the position for new Indian Motorcycle credit tier records.'
  task indian_fix_position: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
        -- Update Indian Tier 1
        UPDATE credit_tiers
        SET position = 11	
        WHERE description ilike 'Tier 1 (FICO%'
        AND make_id = 94;

        -- Update Indian Tier 2
        UPDATE credit_tiers
        SET position = 12	
        WHERE description ilike 'Tier 2 (FICO%'
        AND make_id = 94;

        -- Update Indian Tier 3
        UPDATE credit_tiers
        SET position = 13	
        WHERE description ilike 'Tier 3 (FICO%'
        AND make_id = 94;

        -- Update Indian Tier 4
        UPDATE credit_tiers
        SET position = 14	
        WHERE description ilike 'Tier 4 (FICO%'
        AND make_id = 94;

        -- Update Indian Tier 6 (no tier 5 update)
        UPDATE credit_tiers
        SET position = 15	
        WHERE description ilike 'Tier 5 (FICO%'
        AND make_id = 94;

        -- Update Indian Tier 7
        UPDATE credit_tiers
        SET position = 16	
        WHERE description ilike 'Tier 6 (FICO%'
        AND make_id = 94;
    SQL
  end
end
