namespace :load_model_group_to_credit_tiers do

    desc 'Update Maximum advance percentage'
    task update_maximum_advance_percentage: :environment do
      ActiveRecord::Base.connection.execute(<<-SQL)

            /* Update Harley Tier 1 */
            UPDATE credit_tiers
            SET maximum_advance_percentage = 120.00
            WHERE description ilike 'Tier 1 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 2 */
            UPDATE credit_tiers
            SET irr_value = 16.0
                , maximum_advance_percentage = 115.00
            WHERE description ilike 'Tier 2%'
            AND make_id = 1;

            /* Update Harley Tier 3 */
            UPDATE credit_tiers
            SET maximum_advance_percentage = 110.00
            WHERE description ilike 'Tier 3 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 4 */
            UPDATE credit_tiers
            SET maximum_advance_percentage = 100.00
            WHERE description ilike 'Tier 4 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 6 (no tier 5 update) */
            UPDATE credit_tiers
            SET irr_value = 30.00
                , maximum_advance_percentage = 80.0
            WHERE description ilike 'Tier 6 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 7 */
            UPDATE credit_tiers
            SET irr_value = 34.00
                , maximum_advance_percentage = 70.0
            WHERE description ilike 'Tier 7 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 8 */
            UPDATE credit_tiers
            SET irr_value = 38.00
                , maximum_advance_percentage = 65.0
            WHERE description ilike 'Tier 8 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 9 */
            UPDATE credit_tiers
            SET irr_value = 42.00
                , maximum_advance_percentage = 60.0
            WHERE description ilike 'Tier 9 (FICO%'
            AND make_id = 1;

            /* Update Harley Tier 10 */
            UPDATE credit_tiers
            SET irr_value = 46.00
                , maximum_advance_percentage = 50.0
            WHERE description ilike 'Tier 10 (FICO%'
            AND make_id = 1;

            /* No Indian updates */

        SQL
    end

    desc 'Load Model Group To Credit Tiers'
    task load: :environment do
      ActiveRecord::Base.connection.execute(<<-SQL)

            UPDATE credit_tiers
            SET model_group_id = 9
            WHERE make_id = 94;
            
            UPDATE credit_tiers
            SET model_group_id = 11
            WHERE make_id = 1;
            
            
            /* Harley-Davidson Cruisers */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 8, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 8, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 8, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 8, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 8, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 8, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 8, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 8, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 8, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 8, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson Dyna */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 5, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 5, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 5, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 5, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 5, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 5, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 5, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 5, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 5, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 5, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson Softail  */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 6, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 6, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 6, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 6, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 6, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 6, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 6, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 6, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 6, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 6, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson Sportster */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 3, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 3, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 3, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 3, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 3, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 3, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 3, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 3, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 3, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 3, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson Street */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 7, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 7, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 7, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 7, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 7, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 7, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 7, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 7, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 7, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 7, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson Touring */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 2, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 2, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 2, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 2, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 2, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 2, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 2, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 2, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 2, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 2, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Harley-Davidson VRSC */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(10, 1, 4, 'Tier 10 (FICO 459 and below)', 45, 10, 60, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(1, 1, 4, 'Tier 1 (FICO 700 or higher)', 12, 20, 125, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(2, 1, 4, 'Tier 2 (FICO 670 - 699)', 18, 20, 120, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(3, 1, 4, 'Tier 3 (FICO 640 - 669)', 20, 20, 115, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(4, 1, 4, 'Tier 4 (FICO 610 - 639)', 22, 15, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(5, 1, 4, 'Tier 5 (FICO 580 - 609)', 26, 15, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(6, 1, 4, 'Tier 6 (FICO 550 - 579)', 28, 10, 90, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(7, 1, 4, 'Tier 7 (FICO 520 - 549)', 30, 10, 80, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 34, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(8, 1, 4, 'Tier 8 (FICO 490 - 519)', 32, 10, 75, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(9, 1, 4, 'Tier 9 (FICO 460 - 489)', 40, 10, 70, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 47, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Indian Motorcycles Scout */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(11, 94, 10, 'Tier 1 (FICO 700 or higher)', 14, 20, 110, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(12, 94, 10, 'Tier 2 (FICO 670 - 699)', 20, 20, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(13, 94, 10, 'Tier 3 (FICO 640 - 669)', 22, 20, 100, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 14, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(14, 94, 10, 'Tier 4 (FICO 610 - 639)', 24, 15, 92.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(15, 94, 10, 'Tier 5 (FICO 580 - 609)', 28, 15, 87.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(16, 94, 10, 'Tier 6 (FICO 550 - 579)', 30, 10, 82.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            /* Indian Motorcycles Sportbikes */
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(11, 94, 12, 'Tier 1 (FICO 700 or higher)', 14, 20, 110, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(12, 94, 12, 'Tier 2 (FICO 670 - 699)', 20, 20, 105, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(13, 94, 12, 'Tier 3 (FICO 640 - 669)', 22, 20, 100, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 14, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(14, 94, 12, 'Tier 4 (FICO 610 - 639)', 24, 15, 92.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(15, 94, 12, 'Tier 5 (FICO 580 - 609)', 28, 15, 87.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
            INSERT INTO credit_tiers (position, make_id, model_group_id, description, irr_value, maximum_fi_advance_percentage, maximum_advance_percentage, required_down_payment_percentage,
            security_deposit, enable_security_deposit, acquisition_fee_cents, effective_date, end_date, payment_limit_percentage, created_at, updated_at)
            VALUES(16, 94, 12, 'Tier 6 (FICO 550 - 579)', 30, 10, 82.5, 0, 0, FALSE, 0, CURRENT_DATE, '2999-12-31', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            
        SQL
    end
end
