ActiveAdmin.register MileageTier, namespace: :admins do
  menu parent: 'Calculator Related'
  actions :all, except: [:destroy]

  controller do
    def permitted_params
      params.permit!
    end
  end

  decorate_with Admins::MileageTierDecorator

  index do
    id_column
    column :position
    column :lower
    column :upper
    column :custom_label
    actions
  end

  filter :lower
  filter :upper

  form do |f|
    f.inputs "Model Year Details" do
      f.input :lower
      f.input :upper
      f.input :custom_label
      f.input :position
    end
    f.inputs "Mileage Tier Haircuts" do
      f.input :maximum_frontend_advance_haircut_0, label: 'Current Model Year Haircut'
      f.input :maximum_frontend_advance_haircut_1, label: '1 Year Old Haircut'
      f.input :maximum_frontend_advance_haircut_2, label: '2 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_3, label: '3 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_4, label: '4 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_5, label: '5 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_6, label: '6 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_7, label: '7 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_8, label: '8 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_9, label: '9 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_10, label: '10 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_11, label: '11 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_12, label: '12 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_13, label: '13 Years Old Haircut'
      f.input :maximum_frontend_advance_haircut_14, label: '14 Years Old Haircut'
    end
    f.actions
  end

  show do |resource|
    attributes_table do
      row :lower
      row :upper
      row :custom_label
      row :position
      row 'Current Model Year Haircut' do
        resource.maximum_frontend_advance_haircut_0
      end
      row '1 Year Old Haircut' do
        resource.maximum_frontend_advance_haircut_1
      end
      2.upto(14).each do |num|
        row "#{num} Years Old Haircut" do
          resource.send("maximum_frontend_advance_haircut_#{num}")
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
