namespace :db do
  namespace :schema do
    desc 'Load Custom DB Objects'
    task load_custom_objects: :environment do
      today = Date.today.strftime('%Y%m%d')
      ActiveRecord::Base.connection.execute(<<-SQL)

        DELETE FROM curr_date;
        INSERT INTO curr_date (value) VALUES ('#{today}');

        CREATE SEQUENCE IF NOT EXISTS next_application_identifier_seq
          START WITH 1
          INCREMENT BY 1
          NO MINVALUE
          NO MAXVALUE
          CACHE 1;

        CREATE OR REPLACE FUNCTION next_application_identifier_func() RETURNS character varying
          LANGUAGE plpgsql
          AS $$
            DECLARE
              current_application_date varchar(8) := (SELECT to_char(clock_timestamp() at time zone 'EST5EDT', 'yyyymmdd'));
              last_application_date varchar(8):= (SELECT value FROM curr_date LIMIT 1)::varchar(8);
              dated_id varchar(12);

            BEGIN
              IF current_application_date != last_application_date THEN
                ALTER SEQUENCE next_application_identifier_seq RESTART WITH 1;
                DELETE FROM curr_date;
                INSERT INTO curr_date (value) VALUES (current_application_date);
              END IF;
              dated_id := (SELECT to_char(clock_timestamp() at time zone 'EST5EDT', 'yyyymmdd')||trim(to_char(nextval('next_application_identifier_seq'),'0999')));
              RETURN dated_id;
            END;
          $$;
        SQL
    end
  end
end

namespace :make do
  desc "Load make"
  task load_makes: :environment do
    Make.create(name: "Harley-Davidson", vin_starts_with: "1HD", lms_manf: "HARLEY-DAV", nada_enabled: true, active: true)
  end
end

namespace :model_group do
  desc "Load model group"
  task load_model_groups: :environment do
    make_id =  Make.where(name: "Harley-Davidson").pluck(:id)

    ModelGroup.create(id: 2, name: "Touring", make_id: make_id, minimum_dealer_participation_cents: 20000, residual_reduction_percentage: 90.0, 
      maximum_term_length: 60, backend_advance_minimum_cents: 100000, maximum_haircut_0: 1.00, maximum_haircut_1: 1.00, 
      maximum_haircut_2: 1.00, maximum_haircut_3: 1.00, maximum_haircut_4: 1.00, maximum_haircut_5: 1.00, maximum_haircut_6: 1.00, 
      maximum_haircut_7: 1.00, maximum_haircut_8: 1.00, maximum_haircut_9: 1.00, maximum_haircut_10: 1.00, maximum_haircut_11: 0.95, 
      maximum_haircut_12: 0.95, maximum_haircut_13: 0.95, maximum_haircut_14: 0.95, sort_index: 1 )
  end
end

namespace :credit_tier do
  desc "Load credit tier"
  task load_credit_tier: :environment do
    make_id =  Make.where(name: "Harley-Davidson").pluck(:id)
    model_group_id =  ModelGroup.where(name: "Touring").pluck(:id)

    CreditTier.create(id: 70, description: "Tier 10 (FICO 459 and below)", irr_value: 46.00, maximum_fi_advance_percentage: 10.00, 
      maximum_advance_percentage: 50.00, required_down_payment_percentage: 0.00, security_deposit: 0, enable_security_deposit: false,
      effective_date: "2020-06-13", end_date: "2999-12-31", payment_limit_percentage: 12.00, model_group_id: model_group_id )

    CreditTier.create(id: 71, description: "Tier 1 (FICO 700 or higher)", irr_value: 12.00, maximum_fi_advance_percentage: 20.00, 
      maximum_advance_percentage: 120.00, required_down_payment_percentage: 0.00, security_deposit: 0, enable_security_deposit: false,
      effective_date: "2020-06-13", end_date: "2999-12-31", payment_limit_percentage: 15.00, model_group_id: model_group_id )

    CreditTier.create(id: 72, description: "Tier 2 (FICO 670 - 699)", irr_value: 16.00, maximum_fi_advance_percentage: 20.00, 
      maximum_advance_percentage: 115.00, required_down_payment_percentage: 0.00, security_deposit: 0, enable_security_deposit: false,
      effective_date: "2020-06-13", end_date: "2999-12-31", payment_limit_percentage: 13.00, model_group_id: model_group_id )

    CreditTier.create(id: 73, description: "Tier 3 (FICO 640 - 699)", irr_value: 20.00, maximum_fi_advance_percentage: 20.00, 
      maximum_advance_percentage: 115.00, required_down_payment_percentage: 0.00, security_deposit: 0, enable_security_deposit: false,
      effective_date: "2020-06-13", end_date: "2999-12-31", payment_limit_percentage: 13.00, model_group_id: model_group_id )
  end
end

namespace :acc_range do
  desc "Load Adjusted Capitalized Cost Range"
  task load_acc_range: :environment do
    credit_tier_id = CreditTier.where(description: "Tier 1 (FICO 700 or higher)").pluck(:id)

    AdjustedCapitalizedCostRange.create(id: 289, acquisition_fee_cents: 29500, adjusted_cap_cost_lower_limit: 1, 
      adjusted_cap_cost_upper_limit: 499999, credit_tier_id: credit_tier_id, effective_date: "2020-06-13", end_date: "2999-12-31" )
  end
end

Rake::Task["db:schema:load"].enhance do
  Rake::Task["db:schema:load_custom_objects"].invoke
end

Rake::Task["db:test:prepare"].enhance do
  Rake::Task["db:schema:load_custom_objects"].invoke
  Rake::Task["make:load_makes"].invoke
  Rake::Task["model_group:load_model_groups"].invoke
  Rake::Task["credit_tier:load_credit_tier"].invoke
  Rake::Task["acc_range:load_acc_range"].invoke
end