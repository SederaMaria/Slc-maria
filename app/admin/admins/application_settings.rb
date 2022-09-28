# ActiveAdmin.register ApplicationSetting, namespace: :admins, menu: false do
  
#   menu parent: "Administration", if: proc{ current_admin_user.is_administrator? }

#   actions :all, except: [:destroy]
#   decorate_with ApplicationSettingDecorator
#   config.sort_order = 'id_asc'

#   controller do
#     def permitted_params
#       params.permit!
#     end
#   end

#   menu label: 'Make Specific Finance Settings', parent: "Administration", if: proc{ current_admin_user.is_administrator? }

#   form do |f|
#     inputs "Application Settings" do
#       f.input :make_id, label: "Make", as: :select, collection:  Make.active.pluck(:name, :id)
#       f.input :high_model_year
#       f.input :low_model_year
#       f.input :acquisition_fee, as: :number
#       f.input :base_servicing_fee, as: :number
#       f.input :global_security_deposit, as: :number
#       f.input :enable_global_security_deposit, as: :boolean, wrapper_html: { class: 'col-sm-12' }
#       f.input :dealer_participation_sharing_percentage_24
#       f.input :dealer_participation_sharing_percentage_36
#       f.input :dealer_participation_sharing_percentage_48
#       f.input :dealer_participation_sharing_percentage_60
#       f.input :residual_reduction_percentage_24
#       f.input :residual_reduction_percentage_36
#       f.input :residual_reduction_percentage_48
#       f.input :residual_reduction_percentage_60
      
#       f.actions
#     end
#   end

#   show do |resource|
#     attributes_table do
#       row :make_id do
#         resource.make.try(:name)
#       end
#       row :high_model_year
#       row :low_model_year
#       row :base_servicing_fee do
#         humanized_money_with_symbol(resource.base_servicing_fee)
#       end
#       row :global_security_deposit do
#         humanized_money_with_symbol(resource.global_security_deposit)
#       end
#       row :enable_global_security_deposit do
#         resource.enable_global_security_deposit ? 'Enabled' : 'Disabled'
#       end
#       row :dealer_participation_sharing_percentage_24 do
#         number_to_percentage(resource.dealer_participation_sharing_percentage_24, precision: 2)
#       end
#       row :dealer_participation_sharing_percentage_36 do
#         number_to_percentage(resource.dealer_participation_sharing_percentage_36, precision: 2)
#       end
#       row :dealer_participation_sharing_percentage_48 do
#         number_to_percentage(resource.dealer_participation_sharing_percentage_48, precision: 2)
#       end
#       row :dealer_participation_sharing_percentage_60 do
#         number_to_percentage(resource.dealer_participation_sharing_percentage_60, precision: 2)
#       end
#       row :residual_reduction_percentage_24 do
#         number_to_percentage(resource.residual_reduction_percentage_24, precision: 2)
#       end
#       row :residual_reduction_percentage_36 do
#         number_to_percentage(resource.residual_reduction_percentage_36, precision: 2)
#       end
#       row :residual_reduction_percentage_48 do
#         number_to_percentage(resource.residual_reduction_percentage_48, precision: 2)
#       end
#       row :residual_reduction_percentage_60 do
#         number_to_percentage(resource.residual_reduction_percentage_60, precision: 2)
#       end
      
#       row :updated_at
#     end
#     active_admin_comments
#   end

#   index title: 'Finance Settings' do
#     column :id 
#     column :make_id do |resource|
#       resource.make.try(:name)
#     end
#     column :high_model_year
#     column :low_model_year
#       column :base_servicing_fee do |resource|
#         humanized_money_with_symbol(resource.base_servicing_fee)
#       end
#       column :global_security_deposit do |resource|
#         humanized_money_with_symbol(resource.global_security_deposit)
#       end
#       column :enable_global_security_deposit do |resource|
#         resource.enable_global_security_deposit ? 'Enabled' : 'Disabled'
#       end
#       column :dealer_participation_sharing_percentage_24 do |resource|
#         number_to_percentage(resource.dealer_participation_sharing_percentage_24, precision: 2)
#       end
#       column :dealer_participation_sharing_percentage_36 do |resource|
#         number_to_percentage(resource.dealer_participation_sharing_percentage_36, precision: 2)
#       end
#       column :dealer_participation_sharing_percentage_48 do |resource|
#         number_to_percentage(resource.dealer_participation_sharing_percentage_48, precision: 2)
#       end
#       column :dealer_participation_sharing_percentage_60 do |resource|
#         number_to_percentage(resource.dealer_participation_sharing_percentage_60, precision: 2)
#       end
#       column :residual_reduction_percentage_24 do |resource|
#         number_to_percentage(resource.residual_reduction_percentage_24, precision: 2)
#       end
#       column :residual_reduction_percentage_36 do |resource|
#         number_to_percentage(resource.residual_reduction_percentage_36, precision: 2)
#       end
#       column :residual_reduction_percentage_48 do |resource|
#         number_to_percentage(resource.residual_reduction_percentage_48, precision: 2)
#       end
#       column :residual_reduction_percentage_60 do |resource|
#         number_to_percentage(resource.residual_reduction_percentage_60, precision: 2)
#       end
      
#     column :updated_at
#     actions
#   end

#   breadcrumb do
#     [] #disable for now....
#   end
  
#   filter :make, as: :select, collection: proc { Make.active.pluck(:name, :id) }, label: 'Make'
#   filter :high_model_year
#   filter :low_model_year
#   filter :created_at
#   filter :updated_at
#   filter :acquisition_fee_cents
#   filter :dealer_participation_sharing_percentage_24
#   filter :base_servicing_fee_cents
#   filter :dealer_participation_sharing_percentage_36
#   filter :dealer_participation_sharing_percentage_48
#   filter :residual_reduction_percentage_24
#   filter :residual_reduction_percentage_36
#   filter :residual_reduction_percentage_48
#   filter :residual_reduction_percentage_60
#   filter :dealer_participation_sharing_percentage_60
#   filter :global_security_deposit
#   filter :enable_global_security_deposit

# end
