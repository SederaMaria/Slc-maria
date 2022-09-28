ActiveAdmin.register Audit, namespace: :admins do
  decorate_with Admins::AuditDecorator

  actions :index, :show

  index do
    column 'Date', :created_at, class: 'column-date'
    column 'Audited', :audited, class: 'column-audited'
    column 'By Who', :user, class: 'column-user'
    column 'Changes', :audited_changes, class: 'column-changes'
    actions
  end

  show do |audit|
    attributes_table do
      row :audited
      row :user
      row :audited_changes
    end
  end

  controller do
    def scoped_collection
      super.with_no_tokens.includes(:audited, :user).limit(1000)
    end

    def show
      @page_title = "Audit #{resource.id}"
    end
  end

  filter :audited_type
  filter :audited_id
  filter :user_type
  filter :user_id
  filter :audited_changes
end