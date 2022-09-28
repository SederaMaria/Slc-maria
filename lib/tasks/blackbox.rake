namespace :blackbox do
  desc 'Load leadID'
  task lead_ids_167581260: :environment do
    LeaseApplicationBlackboxRequest.all.each do |record|
      record.update_column(:leadrouter_lead_id, record.leadrouter_response["leadID"])
    end
  end

  desc 'Load lessee'
  task laod_lessee_los_85: :environment do
    LeaseApplicationBlackboxRequest.all.each do |record|
      if !record&.leadrouter_request_body.nil?
        if record&.leadrouter_request_body["applicantType"] == "coapplicant"
          record.update_column(:lessee_id, record&.lease_application&.colessee&.id)
        else
          record.update_column(:lessee_id, record&.lease_application&.lessee&.id) if record.lessee.nil?
        end
      else
        record.update_column(:lessee_id, record&.lease_application&.lessee&.id) if record.lessee.nil?
      end
    end
  end


  desc 'Seed Blackbox Model'
  task seed_blackbox_model: :environment do
    if BlackboxModel.all.empty?
      BlackboxModel.create(blackbox_version: '2021.05.03', model_date: '2021-05-03', default_model: true)
    end
  end



  desc 'Seed Blackbox Model Details'
  task seed_blackbox_model_details: :environment do
    if BlackboxModelDetail.all.empty?
      blackbox_model_details_data.each do |detail|
        BlackboxModelDetail.create(detail)
      end
    end
  end


  desc 'Update credit_score for Blackbox Model Details'
  task update_credit_score: :environment do
    unless BlackboxModelDetail.all.empty?
      credit_score_data.each do |credit|
        details = BlackboxModelDetail.where(blackbox_tier: credit[:blackbox_tier])
        details.update_all(credit_score_greater_than: credit[:credit_score_greater_than], credit_score_max: credit[:credit_score_max]) unless details.empty?
      end
    end
  end


  private

  def blackbox_model_details_data
    blackbox_model_id = BlackboxModel.first.id
    [
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 1, irr_value: 12.00,	maximum_fi_advance_percentage: 20.00,	maximum_advance_percentage: 120.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 15.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 2, irr_value: 16.00,	maximum_fi_advance_percentage: 20.00,	maximum_advance_percentage: 115.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 15.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 3, irr_value: 20.00,	maximum_fi_advance_percentage: 20.00,	maximum_advance_percentage: 110.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 14.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 4, irr_value: 22.00,	maximum_fi_advance_percentage: 15.00,	maximum_advance_percentage: 100.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 5, irr_value: 26.00,	maximum_fi_advance_percentage: 15.00,	maximum_advance_percentage: 90.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 6, irr_value: 30.00,	maximum_fi_advance_percentage: 10.00,	maximum_advance_percentage: 80.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 7, irr_value: 34.00,	maximum_fi_advance_percentage: 10.00,	maximum_advance_percentage: 70.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 8, irr_value: 38.00,	maximum_fi_advance_percentage: 10.00,	maximum_advance_percentage: 65.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 9, irr_value: 42.00,	maximum_fi_advance_percentage: 10.00,	maximum_advance_percentage: 60.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 },
      { blackbox_model_id: blackbox_model_id, blackbox_tier: 10,  irr_value: 46.00,	maximum_fi_advance_percentage: 10.00,	maximum_advance_percentage: 50.00, required_down_payment_percentage: 0.00 ,security_deposit: 0,	enable_security_deposit: false, acquisition_fee_cents: 0,	payment_limit_percentage: 12.00 }
    ]
  end


  def credit_score_data
    [
      { credit_score_greater_than: 744, credit_score_max: 850, blackbox_tier: 1 },
      { credit_score_greater_than: 719, credit_score_max:	744, blackbox_tier: 2 },
      { credit_score_greater_than: 694, credit_score_max:	719, blackbox_tier: 3 },
      { credit_score_greater_than: 669, credit_score_max:	694, blackbox_tier: 4 },
      { credit_score_greater_than: 644, credit_score_max:	669, blackbox_tier: 5 },
      { credit_score_greater_than: 619, credit_score_max:	644, blackbox_tier: 6 },
      { credit_score_greater_than: 594, credit_score_max:	619, blackbox_tier: 7 },
      { credit_score_greater_than: 569, credit_score_max:	594, blackbox_tier: 8 },
      { credit_score_greater_than: 543, credit_score_max:	569, blackbox_tier: 9 },
      { credit_score_greater_than: 350, credit_score_max:	543, blackbox_tier: 10 }
    ]
  end

end

