ActiveAdmin.register CommonApplicationSetting, namespace: :admins do
  
  menu parent: "Administration", url: -> { admins_common_application_setting_path(id: 1) }, if: proc{ current_admin_user.is_administrator? }

  actions :all, except: :destroy
  decorate_with CommonApplicationSettingDecorator


  controller do
    def permitted_params
      params.permit!
    end
  end

  actions :show, :edit, :update

  controller do
    defaults singleton: true

    def resource
      @resource ||= CommonApplicationSetting.instance.decorate
    end
  end


  form do |f|
    inputs "Common Application Settings" do
      f.input :underwriting_hours
      f.input :company_term, as: :file, label: 'Company Term File', hint: f.object.filename
      f.input :funding_approval_checklist, as: :file, label: 'Funding Approval Checklist', hint: f.object.funding_approval_checklist_filename
      f.input :power_of_attorney_template, as: :file, label: 'Power of Attorney Template', hint: f.object.power_of_attorney_template_filename
      f.input :illinois_power_of_attorney_template, as: :file, label: 'Illinois Power of Attorney Template', hint: f.object.illinois_power_of_attorney_template_filename
      f.input :funding_request_form, as: :file, label: 'Funding Request Form', hint: f.object.funding_request_form
      f.input :deactivate_dealer_participation, as: :boolean, wrapper_html: { class: 'col-sm-12' }
      f.input :require_primary_email_address, as: :boolean, wrapper_html: { class: 'col-sm-12' }


      actions do
        action :submit
        cancel_link admins_common_application_setting_path(id: 1)
      end
    end
  end

  show do |resource|
    attributes_table do
      row :company_term do
        link_to resource.filename, resource.file_url if resource.has_company_term?
      end
      row :underwriting_hours
      row :funding_approval_checklist do
        link_to resource.funding_approval_checklist_filename, resource.funding_approval_checklist_url if resource.funding_approval_checklist_url.present?
      end
      row :power_of_attorney_template do
        link_to resource.power_of_attorney_template_filename, resource.power_of_attorney_template_url if resource.power_of_attorney_template_url.present?
      end
      row :illinois_power_of_attorney_template do
        link_to resource.illinois_power_of_attorney_template_filename, resource.illinois_power_of_attorney_template_url if resource.illinois_power_of_attorney_template_url.present?
      end
      row :funding_request_form do
        link_to resource.funding_request_form_filename, resource.funding_request_form_url if resource.has_funding_request_form?
      end
      row :updated_at
      row :deactivate_dealer_participation do
        resource.deactivate_dealer_participation ? 'Enabled' : 'Disabled'
      end
      row :require_primary_email_address 
    end
    active_admin_comments
  end
end