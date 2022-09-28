class ExportTaxJurisdictionsJob
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
    DealerMailer.tax_jurisdictions_export(recipient: recipient, filepath: filepath).deliver_now
  end

  def generate_csv
    CSV.open(filepath, 'wb', headers: true) do |csv|
      csv << headers
      
      model.ransack(filter).result.find_each do |application|
        csv << values(application)
      end
    end
  end

  private

  def model
    TaxJurisdiction
  end

  def values(app)
    mappings(app).values
  end

  def headers
    mappings(TaxJurisdiction.first).keys
  end

  def mappings(app)
    {
        'Name'                        => app.name,
        'US STATE'                    => app.us_state,
        'State Tax Rule'              => app.state_tax_rule&.name,
        'County Tax Rule'             => app.county_tax_rule&.name,
        'Local Tax Rule'              => app.local_tax_rule&.name,
        'Total Sales Tax Percentage'  => "#{app.total_sales_tax_percentage} %",
    }
  end

  def filepath
    @filepath ||= "#{Rails.root.to_s}/tmp/tax_jurisdictions_export_#{Time.now.to_i}.csv"
  end
end
