ActiveAdmin.register Stipulation, namespace: :admins do
  menu parent: 'Administration', if: proc{ current_admin_user.is_administrator? }

  controller do
    def permitted_params
      params.permit!
    end

    def show
      if !!request.xhr?
        render json: resource
      else
        super
      end
    end

    # override for custom sorting using position and then id
    def apply_sorting(chain)
      params[:order] ||= active_admin_config.sort_order
      order_clause = ActiveAdmin::OrderClause.new nil, params[:order]
      if order_clause.field == 'id'
        chain.reorder("position asc, id #{order_clause.order}")
      else
        super
      end
    end
  end

  form do |f|
    f.inputs  do
      f.input :description
      f.input :abbreviation
      f.input :separator, label: 'Separator (between stipulation description and notes)'
      f.input :position
      f.input :required
      f.input :post_submission_stipulation
      f.input :pre_income_stipulation
      f.input :post_income_stipulation
      f.input :blocks_credit_status_approved
      f.input :verification_call_problem
      f.input :stipulation_credit_tier_type_ids, :as=>:check_boxes, :collection=>StipulationCreditTierType.all.pluck(:description, :id), label: "Credit Tiers (applies only to Blocks Credit Status Approved)"
      f.input :active, as: :select
    end
    f.actions
  end
  
  filter :description
  filter :abbreviation
  filter :active
end
