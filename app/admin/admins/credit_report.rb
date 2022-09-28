ActiveAdmin.register CreditReport, namespace: :admins do
  menu parent: "Lessee Related"
  actions :all, except: [:destroy, :edit]
  config.filters = false

  controller do
    def scoped_collection
      super.includes(:lessee).limit(1000)
    end

    def permitted_params
      params.permit!
    end
  end

  member_action :toggle_visibility, method: :put do
    resource.toggle! :visible_to_dealers
    redirect_back fallback_location: admins_root_path, notice: 'Visibility changed successfully'
  end

  member_action :download_credco_xml, method: :get do
    tempfile = Tempfile.new(["Credit Report #{resource.id}", ".xml"])
    tempfile.binmode
    tempfile.write(resource.credco_xml)
    send_file tempfile, type: "application/xml", x_sendfile: true, filename: "Credit Report #{resource.id}.xml"
  end

  index do
    id_column
    column "Lessee" do |report|
      link_to report.lessee&.full_name, admins_lessee_path(report.lessee)
    end
    column :status
    column "Download Link" do |report|
      link_to 'Download', report.upload.url, target: '_blank'
    end
    column :created_at
    column :updated_at
    column "Errors" do |report|
      report.record_errors_v1 unless report.record_errors.blank?
    end
    actions
  end

  show do |report|
    cls = []
    bankruptcies = []
    if report.status == "success"
      credco_xml = report&.credco_xml
      if credco_xml.present?
        doc = Nokogiri::XML(credco_xml) 
        doc = Hash.from_xml(doc.to_s)
        credit_liabilities = doc['RESPONSE_GROUP']['RESPONSE']['RESPONSE_DATA']['CREDIT_RESPONSE']['CREDIT_LIABILITY']
        if credit_liabilities.present?
          credit_liabilities.each do |cl|
            if cl['_HIGHEST_ADVERSE_RATING'].present? && cl['_HIGHEST_ADVERSE_RATING']['_Type'] == 'Repossession'
              date = cl['_HIGHEST_ADVERSE_RATING']['_Date']&.split('-')
              date = "#{Date::ABBR_MONTHNAMES[date&.last.to_i]}-#{date.first}" if date.present?
              notes = cl['CREDIT_COMMENT'][1]['_Text']&.split('Derogatory FootNote')&.last rescue ''
              cls << {name: cl['_CREDITOR']['_Name'], date: date, notes: notes}
            end
          end
        end
        credit_public_record = doc['RESPONSE_GROUP']['RESPONSE']['RESPONSE_DATA']['CREDIT_RESPONSE']['CREDIT_PUBLIC_RECORD']
        records = []
        records = credit_public_record.class == Array ? credit_public_record : records.push(credit_public_record)
        records.compact.each do |record|
          if (record['_Type'].start_with?("Bankruptcy"))
            filed_date = record['_FiledDate']&.split("-")
            filed_date = "#{Date::ABBR_MONTHNAMES[filed_date&.second.to_i]}-#{filed_date&.first}" if filed_date.present?
            status_date = record.dig('_DispositionDate')&.split("-")
            status_date = "#{Date::ABBR_MONTHNAMES[status_date&.second.to_i]}-#{status_date&.first}" if status_date.present?
            bankruptcies << {
              filed_date: filed_date,
              type: record['_Type'],
              status: record.dig('_DispositionType'),
              status_date: status_date
            }
          end
        end
      end
    end
    attributes_table do
      row :description do
        "Credit Report for #{report.lessee&.full_name}"
      end
      row :status
      row "Errors" do |report|
        report.record_errors_v1
      end
      row 'Equifax Credit Score' do |report|
        report.credit_score_equifax
      end
      row 'Experian Credit Score' do |report|
        report.credit_score_experian
      end
      row 'Transunion Credit Score' do |report|
        report.credit_score_transunion
      end
      row 'Average Credit Score' do |report|
        report.credit_score_average.nil? ? "N/A" : report.credit_score_average
      end
      row 'Bankruptcies' do |report|
        bankruptcies.blank? ? 0 : bankruptcies.count
      end
      row 'Repossessions' do |report|
        cls.blank? ? 0 : cls.count
      end
      row "Download Link" do
        link_to 'Download', report.upload.url, target: '_blank'
      end
      row "Download XML" do
        link_to 'Download XML', download_credco_xml_admins_credit_report_path(resource) if resource.credco_xml.present?
      end
      row "Effective Date" do |report|
        report&.effective_date&.strftime('%B %-d %Y at %r %Z') rescue ''
      end
      row "End Date" do |report|
        report&.end_date&.strftime('%B %-d %Y at %r %Z') rescue ''
      end
      row :created_at do |report|
        I18n.localize(report.created_at.in_time_zone('Eastern Time (US & Canada)'), format: :default)
      end
    end

    panel("Bankruptcies") do
      table_for(bankruptcies) do |cl|
        column 'DATE FILED' do |c|
          c[:filed_date]
        end
        column 'TYPE' do |c|
          c[:type]
        end
        column 'STATUS' do |c|
          c[:status]
        end
        column 'STATUS DATE' do |c|
          c[:status_date]
        end
      end
    end
   
    panel("Repossessions") do
      #unless cls.blank?
        table_for(cls) do |cl|
          column 'DATE' do |c|
            c[:date]
          end
          column 'CREDITOR' do |c|
            c[:name]
          end
          column 'NOTES' do |c|
            c[:notes]
          end
        end
      #end
    end
    active_admin_comments
  end
end