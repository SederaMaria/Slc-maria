module TemplateTagHelper
  
    def funding_package_received_template_email(app)
        template = EmailTemplate.lease_package_recieved&.template
        template.sub! '{dealership_name}', app&.dealership&.name
        template.sub! '{lease_vehicle_year}', app&.lease_calculator&.asset_year&.to_s || ""
        template.sub! '{lease_vehicle_make}', app&.lease_calculator&.asset_make || ""
        template.sub! '{lease_vehicle_model}', app&.lease_calculator&.asset_model || ""
        template.sub! '{payment_frequency}', app&.payment_frequency&.humanize || ""
        template.sub! '{payment_dates}',  app&.ordinalize_payment_dates&.to_s || ""
        template.sub! '{payment_amount}',  ActionController::Base.helpers.number_to_currency(app&.payment_amount)&.to_s
        template.sub! '{first_payment_date}',  app&.first_payment_date&.strftime("%B %d, %Y") || ""
        template.sub! '{lease_number}',  app&.application_identifier
        template
    end
    
    def blackbox_auto_reject_template_email(app, datax)
        template = EmailTemplate.blackbox_auto_reject&.template

        blackbox_adverse_reason = "<ul>"
        datax.leadrouter_response["adverseReasonCodes"].map{ |reason|  blackbox_adverse_reason << "<li> #{reason['code']} &nbsp; #{reason['description']} </li> ".html_safe  }
        blackbox_adverse_reason << "</ul>"

        blackbox_error = "#{@datax.leadrouter_response.dig("errorDetails", "code").to_s} #{@datax.leadrouter_response.dig("errorDetails", "message").to_s}" 

        template.sub! '{lease_number}',  app&.application_identifier
        template.sub! '{lessee_first_name}',  app&.lessee&.first_name
        template.sub! '{lessee_last_name}',  app&.lessee&.last_name
        template.sub! '{blackbox_adverse_reason}',  blackbox_adverse_reason
        template.sub! '{blackbox_error}',  blackbox_error
        template
    end


  end
