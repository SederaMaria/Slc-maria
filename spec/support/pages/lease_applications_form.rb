module Pages
  module LeasingApplications
    class Form < SitePrism::Page
      element :body, 'body'
      element :first_name, 'input#lease_application_lessee_attributes_first_name'
      element :last_name, 'input#lease_application_lessee_attributes_last_name'
      element :save_button, "input[name='commit']"

      element :errors, 'ul.errors'

      def fill_first_name(value)
        first_name.set(value)
      end

      def fill_last_name(value)
        last_name.set(value)
      end

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end
    end

    class NewPage < Form
      set_url '/dealers/lease_applications/new'
    end

    class EditPage < Form
      set_url '/dealers/lease_applications{/id}/edit'
    end
  end
end
