FactoryBot.define do
  factory :active_admin_comment, class: 'ActiveAdmin::Comment' do
    resource factory: :admin_user
    author factory: :admin_user
    
    namespace { :admin }
    body { 'hey yall' }

  end
end