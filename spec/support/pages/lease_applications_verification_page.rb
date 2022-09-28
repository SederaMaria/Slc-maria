module Pages
  module LeaseApplications
    class Verification < SitePrism::Page
      set_url '/admins/lease_applications{/id}/verification'

      element :body, 'body'

      element :document_status, 'select#lease_application_document_status'
      element :lessee_email,'#lease_application_lessee_email'
      element :funding_delay_on,'#lease_application_funded_on'
      element :funding_approved_on,'#lease_application_funding_approved_on'
      element :funded_on,'#lease_application_funded_on'

      elements :add_insurance_link, 'a[data-placeholder="NEW_INSURANCE_RECORD"]'

      element :save_button, "input[name='commit']"

      element :errors, 'ul.errors'

      def select_document_status(value)
        document_status.select(value)
      end

      def set_lessee_email(value)
        lessee_email.set(value)
      end

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end
    end
  end
end