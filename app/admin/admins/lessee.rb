ActiveAdmin.register Lessee, namespace: :admins do
  #TODO Figure out how to include lease application and dealership.
  # Getting a Preloading instance dependent scopes is not supported.
  # includes :dealership, :lease_application
  menu parent: "Lessee Related"
  actions :all, except: [:destroy, :new, :create]

  controller do
    def permitted_params
      params.permit!
    end
  end

  index do
    id_column
    column :name
    column :date_of_birth
    column :lease_application
    column :dealership
    actions
  end

  show do |lessee|
    attributes_table do
      row :id
      row :lease_application
      row :dealership
      row :name_with_middle_initial
      row :suffix
      row "SSN" do |event|
        event.ssn
      end
      row :date_of_birth
      row :mobile_phone_number
      row :mobile_phone_number_line
      row :mobile_phone_number_carrier
      row :home_phone_number
      row :home_phone_number_line
      row :home_phone_number_carrier
      row :drivers_license_id_number
      row :drivers_license_state
      row :email_address
      row :employment_details
      row :home_address
      row :mailing_address
      row :employment_address
      row :at_address_years
      row :at_address_months
      row :monthly_mortgage
      row :home_ownership
      row :drivers_licence_expires_at
      row :employer_name
      row :time_at_employer_years
      row :time_at_employer_months
      row :job_title
      row "Employment Status" do |event|
        event&.employment_status_definition&.definition&.humanize
      end
      row :employer_phone_number
      row :employer_phone_number_line
      row :employer_phone_number_carrier
      row :gross_monthly_income
      row :other_monthly_income
    end
    
    active_admin_comments
  end

  filter :first_name_or_last_name_cont, label: 'Name'
  filter :date_of_birth
  filter :mobile_phone_number
  filter :home_phone_number

  form do |f|
    f.inputs "Lessee Details" do
      f.input :first_name
      f.input :middle_name
      f.input :last_name
      f.input :suffix
      f.input :email_address
      f.input :ssn, label: 'Social Security Number (SSN)', as: :string
      f.input :date_of_birth, order: [:month, :day, :year], start_year: Date.current.year, end_year: 100.years.ago.year
      f.input :mobile_phone_number
      f.input :home_phone_number
      f.input :drivers_license_id_number
      f.input :drivers_license_state
      f.input :employment_details
    end
    f.inputs :name => "Home Address", :for => :home_address do |address_form|
      render partial: 'lessee_address', locals: { address_form: address_form, resource: f.object.home_address }
    end
    f.inputs :name => "Mailing Address", :for => :mailing_address do |address_form|
      render partial: 'lessee_address', locals: { address_form: address_form, resource: f.object.mailing_address }
    end
    f.inputs :name => "Employment Address", :for => :employment_address do |address_form|
      render partial: 'lessee_address', locals: { address_form: address_form, resource: f.object.employment_address }
    end
    f.actions
  end
end
