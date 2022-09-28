module Pages
  module AdminDealers
    class CreatePage < SitePrism::Page
      set_url '/admins/dealers/new'

      element :body, 'body'
      element :first_name, '#dealer_first_name'
      element :last_name, '#dealer_last_name'
      element :email, '#dealer_email'
      element :password, '#dealer_password'
      element :confirmation, '#dealer_password_confirmation'

      element :flash_messages, '.flashes'
      element :save_button, 'input[name=commit]'
      element :errors, 'ul.errors'

      def submit_form
        execute_script 'window.scrollBy(0,5000)'
        save_button.click
      end
    end
  end
end

