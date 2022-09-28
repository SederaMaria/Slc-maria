require 'csv'
class DataImportService

  DUMMY_PATH = Rails.root.join('lib', 'data', 'NADA_777_Harley.json').freeze
  DUMMY_RESPONSE = File.read(DUMMY_PATH)

  def initialize(method_type:, file_name:)
    @import_method_type = method_type.to_sym
    @import_file_name = file_name
  end

  def import_data_from_nada    
    Make.where(nada_enabled: true).each do |enabled_make|
      # Loop through each make where NADA is enabled
      setting = ApplicationSetting.where(make_id: enabled_make.id).first

      if setting.present?
        if ENV['NADA_ENABLED'] == 'yes'
          CustomLogger.log_info("#{self.class.to_s}#import_data_from_nada", "Fetch NADA data for model: #{enabled_make.name}")
          response = fetch_data_from_nada(enabled_make, setting)
        else 
          CustomLogger.log_info("#{self.class.to_s}#import_data_from_nada", "Getting fake 777 NADA response")
          require 'json'
          response = JSON.parse(DUMMY_RESPONSE)
        end

        if response.present?          
          response['nadaGroup'].each do |res|
            # Loop through each NADA Group in the response
            data = {
              'year' => res['year'],
              'company' => enabled_make.name.upcase,
              'model_name' => res['modelName'],
              'model_group_name' => res['modelGroup'],
              'nada_rough_cents' => res['roughTradeIn'],
              'nada_avg_retail_cents' => res['averageRetail'],
              'original_msrp_cents' => res['msrp'],
              'effective_start_date' => res['effectiveStartDate'],
              'nada_model_number' => res['nadaModelID'],
              'nada_volume_number' => res['nadaVersionID']
            }
            CustomLogger.log_info("#{self.class.to_s}#import_data_from_nada", "Model year data: #{data}")
            ### MAKE / MODEL GROUP / MODEL YEARS INSERT ###
            if (data['model_name'].include? 'I Police') && data['year'].to_s == '2008'
              data['model_name'] = data['model_name'].gsub('I Police', ' Police')
            end

            full_model_name = data['model_name'].downcase
            model_name = data['model_name']&.split(' ')&.first&.downcase

            to_skip = NadaDummyBike.where("make_id = ? and year = ? and LOWER(bike_model_name) like #{ActiveRecord::Base.connection.quote(full_model_name)}", enabled_make.id, data['year'].to_s).exists?            

            if to_skip
              full_model_name = data['model_name']
              CustomLogger.log_info("#{self.class.to_s}#import_data_from_nada", "Skipped NADA dummy bike: #{full_model_name}.")
              next
            end

            name = enabled_make.name
            #start_with = enabled_make.vin_starts_with.presence || ''
            
            #if name.present? && start_with.present?              
            #  make = Make.where(name: name).first_or_create({
            #    vin_starts_with: start_with
            #  })
            if name.present?
              make = Make.where(name: name).first_or_create

              model_group = ModelGroup.where(ModelGroup.arel_table[:name].matches("%#{data['model_group_name']}%"), ModelGroup.arel_table[:make_id].eq(make.id)).first_or_create({
                make: make,
                name: data['model_group_name'].titleize,
              })

              old_model_group = model_group
              slc_model_group = SlcModelGroup.where('model_year = ? and LOWER(model) = ? and make_id = ?', data['year'], data['model_name']&.downcase, make.id).first
              slc_mapping_flag = true

              if slc_model_group.present?
                if (slc_model_group.slc_model_group_name.downcase != model_group.name.downcase) 
                  model_group = ModelGroup.where('LOWER(name) = ? and make_id = ?', slc_model_group.slc_model_group_name&.downcase, make.id).first
                  unless model_group.present?                    
                    slc_mapping_flag = false
                    model_group = old_model_group
                  end
                end
              else                
                slc_mapping_flag = false
              end

              if model_group.present?
                data['model_group_id'] = model_group.id
                todays_date = Date.today
                create_new_model_year = true # default true for first time model year creation

                model_year = model_group.model_years.where(name: data['model_name'], year: data['year'])
                                                    .where("'#{todays_date + 1.day}' BETWEEN start_date AND end_date").last

                # Get the current model_year from the database, if any
                if model_year.present?
                  create_new_model_year = false # turning off as model year already exist
                  
                  nada_model_newer = nada_year_differs_from_los_year(data, model_year, todays_date)                  

                  if nada_model_newer            
                    nada_effective_start_date = (data['effective_start_date'].to_date > todays_date) ? data['effective_start_date'].to_date : todays_date        
                    model_year.update_columns(end_date: nada_effective_start_date)
                    create_new_model_year = true # turning on as model year data changed
                  end
                else
                  my = ModelYear.inactive.where(name: data['model_name'], year: data['year'])
                                                    .where("'#{todays_date + 1.day}' BETWEEN start_date AND end_date").last

                  if my.present?
                    create_new_model_year = false
                  end
                end
                
                police_bike_flag = false

                if (data['model_name'].include? ' Police')
                  # Should only occur for model years prior to 2015
                  police_bike_flag = true
                 end
                    
                if create_new_model_year
                  data['nada_avg_retail_cents'] = data['nada_avg_retail_cents'] * 100
                  data['nada_model_group_name'] = data.delete 'model_group_name'
                  data['nada_rough_cents'] = data['nada_rough_cents'] * 100
                  data['original_msrp_cents'] = data['original_msrp_cents'] * 100
                  data['police_bike'] = police_bike_flag
                  data['slc_model_group_mapping_flag'] = slc_mapping_flag
                  data['start_date'] = (data['effective_start_date'].to_date > todays_date) ? data['effective_start_date'].to_date : todays_date
                  data['end_date'] = '2999-12-31'.to_date

                  create_model_year(data)
                end
              end
            end

          end
        end
      end
    end
    police_bike_rules
    Admins::ModelYearFacade.new.recalculate_residuals
  end

  def send_nada_updates
    new_models = ModelYear.where(:created_at => Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc)
    updated_models = ModelYear.where(end_date: Date.today)
    AdminMailer.models_list(new_models, updated_models).deliver_now
  end

  def fetch_data_from_nada(model, setting)
    require 'net/http'
    require 'net/https'
    require 'json'
    begin
      # _, username, password, host, port = ENV["FIXIE_URL"].gsub(/(:|\/|@)/,' ').squeeze(' ').split
      proxy = URI(ENV["QUOTAGUARDSTATIC_URL"])
      uri = URI(ENV['NADA_API_URL'])
      http = Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port, proxy.user, proxy.password)
      # http = Net::HTTP.new(uri.host, uri.port, host, port, username, password)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json',  
        'Authorization' => ENV['NADA_API_TOKEN']})
      req.body = {'make' => model.name, 'startYear' => setting.low_model_year, 'endYear' => setting.high_model_year}.to_json
      response = http.request(req)
      # puts "response #{res.body}"
      # CustomLogger.log_error("#{self.class.to_s}#fetch_data_from_nada", "NADA API Request Body- \n #{req.body}")
      JSON.parse(response.body)
    rescue => e
      CustomLogger.log_error("#{self.class.to_s}#fetch_data_from_nada", "NADA API Call failed, Exception details- \n #{e}")
      # puts "failed #{e}"
    end
  end

  def import_data_bank_routing
    fields_array =  [["routing_number", 9], ["office_code", 1], ["servicing_frb_number", 9], ["record_type_code", 1], ["change_date", 6], ["new_routing_number", 9], ["customer_name", 36], ["address", 36], ["city", 20], ["state_code", 2], ["zipcode", 5], ["zipcode_extension", 4], ["telephone_area_code", 3], ["telephone_prefix_number", 3], ["telephone_suffix_number", 4], ["institution_status_code", 1], ["data_view_code", 1], ["filler", 5]]
    import_data fields_array do |data|
      CustomLogger.log_info("#{self.class.to_s}#import_data_bank_routing", "#{data}")
      data["change_date"] = Date.strptime(data["change_date"].to_s.rjust(6,"0"), '%m%d%y')
      BankRoutingNumber.find_or_create_by(data)
    end
  end

  def police_bike_rules    
    police_bike_rules = PoliceBikeRule.all
    police_bike_rules.each do |pbr|            

      # Loop through proxies by year
      model_years = ModelYear.active
        .where('year >=  ?', pbr.starting_proxy_year)
        .joins(:model_group)
        .where(:model_groups => {:make_id => pbr.proxy_model_make}, :model_years => {name: pbr.proxy_model_name})

      model_years.each do |model_year|        
        # Check if an active police bike model exists for this proxy
        existing_police_bike = ModelYear.active.where('LOWER(name) = ? and year = ?', pbr.new_model_name&.downcase, model_year.year).first        

        create_new = false

        if existing_police_bike.present?
          # Check if current police bike matches adjusted values for its current proxy
          not_current = police_bike_and_adjusted_proxy_differ(pbr, existing_police_bike, model_year)          

          if not_current
            # Expire the active police bike
            existing_police_bike.update_columns(end_date: Date.today, updated_at: Time.now)
            # We'll create a new one shortly
            create_new = true
          end
        else
          # No active police bike for this proxy. We'll create one shortly
          create_new = true
        end

        if create_new          
          data = {
            'year' => model_year.year,
            'company' => Make.find_by(id: pbr.new_model_make).name,
            'model_name' => pbr.new_model_name,
            'model_group_id' => model_year.model_group_id,
            'nada_rough_cents' => (model_year.nada_rough_cents.to_f * pbr.proxy_rough_value_percent.to_f) / 100,
            'nada_avg_retail_cents' => (model_year.nada_avg_retail_cents.to_f * pbr.proxy_retail_value_percent.to_f) / 100,
            'nada_model_group_name' => model_year&.model_group&.name,
            'original_msrp_cents' => 0,
            'police_bike' => true,
            'slc_model_group_mapping_flag' => true,
            'start_date' => model_year.start_date,
            'end_date' => '2999-12-31'.to_date
          }
          create_model_year(data)
        end

      end
    end
    
  end

  def import_data_for_all_make
    fields_array =  [["company", 0], ["year", 2], ["model_group_name", 3], ["model_name", 4], ["nada_rough_cents", 14], ["nada_avg_retail_cents", 16], ['original_msrp_cents', 13]]
    import_data fields_array do |data|

      CustomLogger.log_info("#{self.class.to_s}#import_data_for_all_make", "#{data}")
      ### MAKE / MODEL GROUP / MODEL YEARS INSERT ###
      name = start_with = ''

      if data["company"] == "HARLEY-DAVIDSON"
        name = 'Harley-Davidson'
        start_with = '1HD'
      elsif data["company"] == "INDIAN MOTORCYCLES" 
        name = 'Indian Motorcycles'
        start_with = ''
      end
      next if NadaDummyBike.where(:make=>data["company"],
        :year=>data["year"],
        :model_group_name=>data["model_group_name"],
        :bike_model_name=>data["model_group_name"],
        :nada_rough_cents=>data["nada_rough_cents"]).exists?

      if name.present?
        make = Make.where(name: name).first_or_create({
          vin_starts_with: start_with
        })

        model_group = ModelGroup.where(ModelGroup.arel_table[:name].matches("%#{data["model_group_name"]}%")).first_or_create({
          make: make,
          name: data["model_group_name"].titleize,
        })

        model_group.model_years.where(name: data["model_name"], year: data["year"]).first_or_create({
          nada_rough: data["nada_rough_cents"].to_money,
          nada_avg_retail: data["nada_avg_retail_cents"].to_money,
          original_msrp: data["original_msrp_cents"].to_money
        })
      end
    end
    Admins::ModelYearFacade.new.recalculate_residuals
  end

  private

  def import_data(fields_array, &process_data)
    if @import_method_type == :fixedwidth
      import_fixed_width_data(fields_array, &process_data)
    elsif @import_method_type == :csv
      import_csv_data(fields_array, &process_data)
    elsif @import_method_type == :psv
      import_delimiter_separated_values_data(fields_array, "|", &process_data)
    else
      CustomLogger.log_info("#{self.class.to_s}#import_data", "Data import type is wrong!")
    end
  end

  def import_fixed_width_data(fields_array, &process_data)
    fields_info = fields_array.transpose
    field_name_array = fields_info[0]
    field_width_array = fields_info[1]
    field_pattern = "A#{field_width_array.join('A')}"
    File.foreach(@import_file_name) do |line|
      row = line.unpack(field_pattern)
      data = field_name_array.zip(row).to_h
      process_data.call(data)
    end
    CustomLogger.log_info("#{self.class.to_s}#import_fixed_width_data", "BankRoutingNumber records import successfully.")
  end

  def import_csv_data(fields_array, &process_data)
    fields_info = fields_array.transpose
    field_name_array = fields_info[0]
    csv_file_data = File.read(@import_file_name)
    csv_data = CSV.parse(csv_file_data)
    csv_data.each do |row|
      data = field_name_array.zip(row).to_h
      process_data.call(data)
    end
    CustomLogger.log_info("#{self.class.to_s}#import_csv_data", "BankRoutingNumber records import successfully.")
  end

  def import_delimiter_separated_values_data(fields_array, delimiter, &process_data)
    fields_info = fields_array.transpose
    field_name_array = fields_info[0]
    field_number_array = fields_info[1]
    csv_file_data = File.read(@import_file_name)
    csv_data = CSV.parse(csv_file_data, :headers => true, :col_sep => delimiter)
    csv_data.each do |row|
      data = {}
      field_name_array.each_with_index do |val,index|
        field_index = field_number_array[index]
        data[val] = row[field_index]
      end
      process_data.call(data)
    end
    CustomLogger.log_info("#{self.class.to_s}#import_delimiter_separated_values_data", "Import records successfully.")
  end

  def create_model_year(model_values)    
    new_model = ModelYear.find_or_initialize_by(
      name: model_values['model_name'],
      year: model_values['year'],
      model_group_id: model_values.key?('model_group_id') ? model_values['model_group_id'] : nil,
      end_date: model_values['end_date'],
      nada_avg_retail_cents: model_values['nada_avg_retail_cents'],
      nada_model_group_name: model_values['nada_model_group_name'],
      nada_model_number: model_values.key?('nada_model_number') ? model_values['nada_model_number'] : nil,
      nada_rough_cents: model_values['nada_rough_cents'],
      nada_volume_number: model_values.key?('nada_volume_number') ? model_values['nada_volume_number'] : nil,
      original_msrp_cents: model_values['original_msrp_cents'],
      police_bike: model_values['police_bike'],
      slc_model_group_mapping_flag: model_values['slc_model_group_mapping_flag'],
      start_date: model_values['start_date']
    )

    if new_model.new_record?
      if new_model.save
        CustomLogger.log_info("#{self.class.to_s}#create_model_year", 
          "Created #{model_values['year']} #{model_values['model_name']} from volume #{model_values['nada_volume_number']}")
      else
        CustomLogger.log_info("#{self.class.to_s}#create_model_year", 
          "Error creating #{model_values['year']} #{model_values['model_name']} from volume #{model_values['nada_volume_number']}")
      end
    end
  end  

  def nada_year_differs_from_los_year(nada_data, model_year, todays_date)    
    #nada_rough = nada_data['nada_rough_cents'].to_money
    #nada_avg_retail = nada_data['nada_avg_retail_cents'].to_money
    #original_msrp = nada_data['original_msrp_cents'].to_money
    nada_effective_start_date = (nada_data['effective_start_date'].to_date > todays_date) ? nada_data['effective_start_date'].to_date : todays_date
    nada_model_number = nada_data['nada_model_number'].to_s
    nada_volume_number = nada_data['nada_volume_number'].to_s

    #if (model_year.original_msrp != original_msrp) || (model_year.nada_rough != nada_rough) || (model_year.nada_avg_retail != nada_avg_retail) || (model_year.nada_model_number != nada_model_number) || (model_year.nada_volume_number != nada_volume_number)
    if (model_year.nada_model_number != nada_model_number) || (model_year.nada_volume_number != nada_volume_number)
      return true
    else
      return false
    end
  end

  def police_bike_and_adjusted_proxy_differ(pbr, police_model, model_year)
    # Set variables with current police bike values
    current_pb_rough_cents = police_model.nada_rough_cents
    current_pb_retail_cents = police_model.nada_avg_retail_cents

    # Set multipliers
    rule_rough_value_percent = pbr.proxy_rough_value_percent
    rule_retail_value_percent = pbr.proxy_retail_value_percent

    # Calculate adjusted values for current proxy
    proxy_rough_cents = (model_year.nada_rough_cents.to_f * rule_rough_value_percent.to_f) / 100
    proxy_retail_cents = (model_year.nada_avg_retail_cents.to_f * rule_retail_value_percent.to_f) / 100

    if (current_pb_rough_cents != proxy_rough_cents) || (current_pb_retail_cents != proxy_retail_cents)
      return true
    else
      return false
    end
  end  

end