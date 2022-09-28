ActiveAdmin.register PoliceBikeRule, namespace: :admins do
  menu parent: 'Asset Related'
  actions :all

  controller do
    def permitted_params
      params.permit!
    end

    def index
      params[:order] = "id_asc"
      super
    end
  end

  index do
    id_column
    column :starting_proxy_year
    column "Proxy Model Make" do |i|
      Make.find_by(id: i.proxy_model_make).name
    end
    column :proxy_model_name
    column "New Model Make" do |i|
      Make.find_by(id: i.new_model_make).name
    end
    column :new_model_name
    column :proxy_rough_value_percent
    column :proxy_retail_value_percent
    actions
  end


	form do |f|
    f.inputs 'Police Bike Rules' do
      f.input :starting_proxy_year, "required": true
      f.input :proxy_model_make, as: :select, collection: Make.all.collect{ |u| [u.name, u.id]},
      	      input_html: { 'data': { placeholder: 'Select Proxy Model Make' }, class: "select2-input", id: 'police_bike_rule_make_id' , "required": true }
      f.input :proxy_model_name,
		      as: :select,
		      collection: Make.find_by(id: resource&.proxy_model_make)&.model_years&.map(&:name) || [],
		      input_html: { 'data': { placeholder: 'Select a Proxy Model Name' }, class: "select2-input", id: 'police_bike_rule_model_year_name', "required": true }
		  f.input :new_model_make, as: :select, collection: Make.all.collect{ |u| [u.name, u.id]},
      	      input_html: { 'data': { placeholder: 'Select New Model Make' }, class: "select2-input" , "required": true}
      f.input :new_model_name, "required": true
	    f.input :proxy_rough_value_percent, step: 0.01, max: 100, min: 1
	    f.input :proxy_retail_value_percent, step: 0.01, max: 100, min: 1
    end

    f.actions do 
      f.action :submit
    end
  end
end