class InsertModelGroupAccAcqFees < ActiveRecord::Migration[5.1]
  def change
		execute "DO
			$do$
			-- Credit Tier records corresponding to Model Group 11 already exist in adjusted_capitalized_cost_ranges HD
			-- Credit Tier records corresponding to Model Group 9 already exist in adjusted_capitalized_cost_ranges IN

			DECLARE accLower integer :=1;
			DECLARE accUpper integer :=499999;
			DECLARE creditTierID integer;
			DECLARE hdAcqFee integer :=29500;
			DECLARE hmCreditTierTemplate integer;
			DECLARE imAcqFee integer :=29500;
			DECLARE imCreditTierTemplate integer;
			DECLARE tierDesc character varying;

			BEGIN
				-- Loop through tiers
				FOR i IN 1..10 LOOP
					tierDesc = CONCAT('Tier ', i, ' (F%');

					-- Set template credit tier ID
					CASE
						WHEN i < 7  THEN 
							SELECT id INTO hmCreditTierTemplate FROM credit_tiers WHERE model_group_id = 11 AND description like tierDesc;
							SELECT id INTO imCreditTierTemplate FROM credit_tiers WHERE model_group_id = 9 AND description like tierDesc;
					ELSE
						SELECT id INTO hmCreditTierTemplate FROM credit_tiers WHERE model_group_id = 11 AND description like tierDesc;
						
					END CASE;
					
					-- Loop through Adjusted Cap Cost ranges
					FOR acc IN 1..6 LOOP
						CASE
							WHEN acc = 1 THEN accLower = 1; accUpper = 499999;
							WHEN acc = 2 THEN accLower = 500000; accUpper = 999999;
							WHEN acc = 3 THEN accLower = 1000000; accUpper = 1499999;
							WHEN acc = 4 THEN accLower = 1500000; accUpper = 1999999;
							WHEN acc = 5 THEN accLower = 2000000; accUpper = 2499999;
							WHEN acc = 6 THEN accLower = 2500000; accUpper = 0;
						ELSE
						END CASE;
					
						-- Set Harley acquisition fee values for this tier
						IF EXISTS(SELECT acquisition_fee_cents 
									  FROM adjusted_capitalized_cost_ranges 
									  WHERE credit_tier_id = hmCreditTierTemplate AND adjusted_cap_cost_lower_limit = accLower)
							THEN SELECT acquisition_fee_cents INTO hdAcqFee 
									FROM adjusted_capitalized_cost_ranges 
									WHERE credit_tier_id = hmCreditTierTemplate AND adjusted_cap_cost_lower_limit = accLower;
						END IF;
					
						-- Set Indian acquisition fee values for this tier
						IF i < 7  THEN			
							IF EXISTS(SELECT acquisition_fee_cents 
										  FROM adjusted_capitalized_cost_ranges 
										  WHERE credit_tier_id = imCreditTierTemplate AND adjusted_cap_cost_lower_limit = accLower)
								THEN SELECT acquisition_fee_cents INTO imAcqFee 
										FROM adjusted_capitalized_cost_ranges 
										WHERE credit_tier_id = imCreditTierTemplate AND adjusted_cap_cost_lower_limit = accLower;
							END IF;			
						END IF;
						
						-- Loop through model_groups
						FOR mg IN 2..12 LOOP
							IF EXISTS(SELECT id FROM credit_tiers WHERE model_group_id = mg AND description LIKE tierDesc)
								THEN SELECT id INTO creditTierID FROM credit_tiers WHERE model_group_id = mg AND description LIKE tierDesc; 
							END IF;	

							CASE
								WHEN (mg IN(2, 3, 4, 5, 6, 7, 8)) THEN
									INSERT INTO adjusted_capitalized_cost_ranges
									(acquisition_fee_cents, adjusted_cap_cost_lower_limit, adjusted_cap_cost_upper_limit, credit_tier_id, effective_date, end_date, created_at, updated_at) 
									VALUES(hdAcqFee, accLower, accUpper, creditTierID, NOW() AT time zone 'utc', '3000-12-31 23:59:00', NOW() AT time zone 'utc', NOW() AT time zone 'utc');									
								WHEN (mg IN(10, 12)) THEN
									IF i < 7  THEN
										INSERT INTO adjusted_capitalized_cost_ranges
										(acquisition_fee_cents, adjusted_cap_cost_lower_limit, adjusted_cap_cost_upper_limit, credit_tier_id, effective_date, end_date, created_at, updated_at) 
										VALUES(imAcqFee, accLower, accUpper, creditTierID, NOW() AT time zone 'utc', '3000-12-31 23:59:00', NOW() AT time zone 'utc', NOW() AT time zone 'utc');						
									END IF;
								ELSE					
							END CASE;
						END LOOP;
					END LOOP;
				END LOOP;
			END
			$do$;"
  end
end
