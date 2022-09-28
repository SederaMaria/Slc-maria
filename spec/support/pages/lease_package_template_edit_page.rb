module Pages
  module LeasingPackageTemplates
    class EditPage < SitePrism::Page
      set_url '/admins/lease_package_templates{/id}/edit'

      element :body, 'body'

      element :name, 'input#lease_package_template_name'
      element :file_field, 'input#lease_package_template_lease_package_template'
      element :save_button, "input[name='commit']"

      element :errors, 'ul.errors'

      def fill_package_template_name(value)
        name.set(value)
      end

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end
    end
  end
end