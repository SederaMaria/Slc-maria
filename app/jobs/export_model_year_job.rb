class ExportModelYearJob
  include Sidekiq::Worker

  sidekiq_options unique:      :until_executed,
                  unique_args: :unique_args

  attr_reader :recipient, :filter

  def self.unique_args(args)
    args[0]['email']
  end

  def perform(opts = {})
    @recipient = opts.with_indifferent_access['email']
    @filter    = opts.with_indifferent_access['filter'] || {}
    generate_csv
    email_to_recipient
    return filepath
  end

  def email_to_recipient
    DealerMailer.model_years_export(recipient: recipient, filepath: @filepath).deliver_now
  end

  def generate_csv
    CSV.open(filepath, 'wb', headers: true) do |csv|
      csv << headers
      model.limit(nil).ransack(filter).result.find_each do |application|
        csv << values(application)
      end
    end
  end

  private

  def model
    ModelYear
  end

  def values(app)
    mappings(app).values
  end

  def headers
    mappings(ModelYear.first).keys
  end

  def mappings(modelyear)
    {
      "ID"                      => modelyear.id,
      "Original MSRP"           => modelyear.original_msrp.to_s,
      "Nada Avg Retail"         => modelyear.nada_avg_retail.to_s,
      "Nada Rough"              => modelyear.nada_rough.to_s,
      "Name"                    => modelyear.name,
      "Year"                    => modelyear.year,
      "Residual 24"             => modelyear.residual_24.to_s,
      "Residual 36"             => modelyear.residual_36.to_s,
      "Residual 48"             => modelyear.residual_48.to_s,
      "Created At"              => modelyear.created_at,
      "Updated At"              => modelyear.updated_at,
      "Model Group ID"          => modelyear.model_group_id,
      "Residual 60"             => modelyear.residual_60.to_s,
      "Maximum Haircut 0"       => modelyear.maximum_haircut_0,
      "Maximum Haircut 1"       => modelyear.maximum_haircut_1,
      "Maximum Haircut 2"       => modelyear.maximum_haircut_2,
      "Maximum Haircut 3"       => modelyear.maximum_haircut_3,
      "Maximum Haircut 4"       => modelyear.maximum_haircut_4,
      "Maximum Haircut 5"       => modelyear.maximum_haircut_5,
      "Maximum Haircut 6"       => modelyear.maximum_haircut_6,
      "Maximum Haircut 7"       => modelyear.maximum_haircut_7,
      "Maximum Haircut 8"       => modelyear.maximum_haircut_8,
      "Maximum Haircut 9"       => modelyear.maximum_haircut_9,
      "Maximum Haircut 10"      => modelyear.maximum_haircut_10,
      "Maximum Haircut 11"      => modelyear.maximum_haircut_11,
      "Maximum Haircut 12"      => modelyear.maximum_haircut_12,
      "Maximum Haircut 13"      => modelyear.maximum_haircut_13,
      "Maximum Haircut 14"      => modelyear.maximum_haircut_14,
      "Start Date"              => modelyear.start_date,
      "End Date"                => modelyear.end_date,
      "Nada Model Number"       => modelyear.nada_model_number,
      "Police Bike"             => modelyear.police_bike,
      "Make"                    => modelyear&.make&.name,
      "Model Group"             => modelyear&.model_group&.name
    }
  end

  def filepath
    @filepath = "#{Rails.root.to_s}/tmp/model_years_export_#{Time.now.to_i}.csv"
  end
end