module Pages
  module LeaseApplicationStipulations
    class CreatePage < SitePrism::Page
      set_url '/admins/lease_applications{/id}/add_stipulations'

      element :body, 'body'

      element :stipulation_id, "select[name='lease_application_stipulation[stipulation_id]']"
      element :attachment_id, "select[name='lease_application_stipulation[lease_application_attachment_id]']"
      element :status_not_required,'#lease_application_stipulation_status_not_required'
      element :status_cleared,'#lease_application_stipulation_status_cleared'
      element :notes,'#lease_application_stipulation_notes'

      element :save_button, "input[name='commit']"


      element :errors, 'ul.errors'

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end
    end
  end
end
