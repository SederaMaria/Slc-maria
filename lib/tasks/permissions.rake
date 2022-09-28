namespace :permissions do
  desc 'Seed Permissions'
  task seed: :environment do
    if Permission.all.empty?
      create_action = Action.find_by(rights: 'create')
      get_action = Action.find_by(rights: 'get')
      update_action = Action.find_by(rights: 'update')

      create_id = create_action&.id
      get_id = get_action&.id
      update_id = update_action&.id

      Resource.all.each do |resource|
        case resource.name
        when 'AdminUser'
          SecurityRole.all.each do |role|
            next unless role.description == 'Administrator'

            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: create_id })
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: get_id })
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: update_id })
          end
        when 'CreditTier'
          SecurityRole.all.each do |role|
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: get_id })

            next unless role.description == 'Administrator'

            Permission.create({ security_role_id: role.id, resource_id: resource.id,
                                action_id: create_id })
            Permission.create({ security_role_id: role.id, resource_id: resource.id,
                                action_id: update_id })
          end
        when 'Dealership'
          SecurityRole.all.each do |role|
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: get_id })

            if role.description == 'Administrator' || role.description == 'Sales Manager' || role.description == 'Sales User'
              Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: create_id })
              Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: update_id })
            elsif role.description == 'Underwriting Manager' || role.description == 'Underwriting User'
              Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: update_id })
            end
          end
        when 'ModelGroup'
          SecurityRole.all.each do |role|
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: get_id })

            next unless role.description == 'Administrator'

            Permission.create({ security_role_id: role.id, resource_id: resource.id,
                                action_id: create_id })
            Permission.create({ security_role_id: role.id, resource_id: resource.id,
                                action_id: update_id })
          end
        when 'VehicleInventory'
          SecurityRole.all.each do |role|
            Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: get_id })

            if role.description == 'Administrator' || role.description == 'Sales Manager' || role.description == 'Sales User'
              Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: create_id })
              Permission.create({ security_role_id: role.id, resource_id: resource.id, action_id: update_id })
            end
          end
        end
      end
    end
  end

  desc 'Add delete action to Administrators'
  task add_inventory_delete_to_admin: :environment do
    role_obj = SecurityRole.find_by(description: 'Administrator')
    resource_obj = Resource.find_by(name: 'VehicleInventory')
    action_obj = Action.find_by(rights: 'delete')

    role_id = role_obj&.id
    resource_id = resource_obj&.id
    action_id = action_obj&.id

    if role_id && resource_id && action_id
      Permission.create({ security_role_id: role_id, resource_id: resource_id, action_id: action_id })
    end
  end

  desc 'Add welcome call permissions'
  task add_welcome_call_permissions: :environment do
    resource_obj = Resource.find_by(name: 'WelcomeCall')
    create_action = Action.find_by(rights: 'create')
    get_action = Action.find_by(rights: 'get')
    update_action = Action.find_by(rights: 'update')

    resource_id = resource_obj&.id
    create_id = create_action&.id
    get_id = get_action&.id
    update_id = update_action&.id

    SecurityRole.all.each do |role|
      Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: get_id })

      if role.description == 'Administrator' || role.description == 'Sales Manager' || role.description == 'Sales User'
        Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: create_id })
        Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: update_id })
      end
    end
  end

  desc 'Remove welcome call update from Sales Users'
  task remove_welcome_call_update_sales_users: :environment do
    resource_obj = Resource.find_by(name: 'WelcomeCall')
    role_obj = SecurityRole.find_by(description: 'Sales User')
    update_action = Action.find_by(rights: 'update')

    resource_id = resource_obj&.id
    role_id = role_obj&.id
    update_id = update_action&.id

    permissions = Permission.where(security_role_id: role_id, resource_id: resource_id, action_id: update_id)
    permissions.destroy_all
  end

  desc 'Add employment verification permissions'
  task add_emp_verify_permissions: :environment do
    resource_obj = Resource.find_by(name: 'EmploymentVerification')
    create_action = Action.find_by(rights: 'create')
    get_action = Action.find_by(rights: 'get')
    update_action = Action.find_by(rights: 'update')

    resource_id = resource_obj&.id
    create_id = create_action&.id
    get_id = get_action&.id
    update_id = update_action&.id

    SecurityRole.all.each do |role|
      unless role.description == 'Administrator' || role.description == 'Executive' || role.description == 'Underwriting Manager' || role.description == 'Underwriting User'
        next
      end

      Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: create_id })
      Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: get_id })
      Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: update_id })
    end
  end

  desc 'Add Dealership Onboarding approval permissions'
  task add_dealership_approval_permissions: :environment do
    dsr_resource_obj = Resource.find_by(name: 'DealershipSalesRecommendation')
    dua_resource_obj = Resource.find_by(name: 'DealershipUnderwritingApproval')
    dcca_resource_obj = Resource.find_by(name: 'DealershipCreditCommitteeApproval')

    dsr_resource_id = dsr_resource_obj&.id
    dua_resource_id = dua_resource_obj&.id
    dcca_resource_id = dcca_resource_obj&.id

    create_action = Action.find_by(rights: 'create')
    get_action = Action.find_by(rights: 'get')
    update_action = Action.find_by(rights: 'update')

    create_id = create_action&.id
    get_id = get_action&.id
    update_id = update_action&.id

    SecurityRole.all.each do |role|
      # Get for all approvals
      Permission.create({ security_role_id: role.id, resource_id: dcca_resource_id, action_id: get_id })
      Permission.create({ security_role_id: role.id, resource_id: dua_resource_id, action_id: get_id })
      Permission.create({ security_role_id: role.id, resource_id: dsr_resource_id, action_id: get_id })

      # Credit Committee Create/Update
      if role.description == 'Administrator' || role.description == 'Executive'
        Permission.create({ security_role_id: role.id, resource_id: dcca_resource_id, action_id: create_id })
        Permission.create({ security_role_id: role.id, resource_id: dcca_resource_id, action_id: update_id })
      end

      # Underwriting Approval Create/Update
      if role.description == 'Administrator' || role.description == 'Underwriting Manager'
        Permission.create({ security_role_id: role.id, resource_id: dua_resource_id, action_id: create_id })
        Permission.create({ security_role_id: role.id, resource_id: dua_resource_id, action_id: update_id })
      end

      # Sales Recommendation Create/Update
      if role.description == 'Administrator' || role.description == 'Sales Manager'
        Permission.create({ security_role_id: role.id, resource_id: dsr_resource_id, action_id: create_id })
        Permission.create({ security_role_id: role.id, resource_id: dsr_resource_id, action_id: update_id })
      end
    end
  end

  desc 'Add lease undewriting permissions'
  task add_lease_underwriting_permissions: :environment do
    review_resource_obj = Resource.find_by(name: 'LeaseWorkflowUnderwritingReview')
    approve_resource_obj = Resource.find_by(name: 'LeaseWorkflowUnderwritingApprove')

    review_resource_id = review_resource_obj&.id
    approve_resource_id = approve_resource_obj&.id

    create_action = Action.find_by(rights: 'create')

    create_id = create_action&.id

    SecurityRole.all.each do |role|
      # Request Underwriting Review
      if role.description == 'Administrator' || role.description == 'Executive' || role.description == 'Underwriting Manager' || role.description == 'Underwriting User'
        Permission.create({ security_role_id: role.id, resource_id: review_resource_id, action_id: create_id })
      end

      # Approve Underwriting
      if role.description == 'Administrator' || role.description == 'Underwriting Manager'
        Permission.create({ security_role_id: role.id, resource_id: approve_resource_id, action_id: create_id })
      end
    end
  end

  desc 'Add vehicle possession permissions'
  task add_vehicle_possession: :environment do
    resource_obj = Resource.find_by(name: 'LeaseVehiclePossession')
    resource_id = resource_obj&.id

    get_action = Action.find_by(rights: 'get')
    update_action = Action.find_by(rights: 'update')

    get_id = get_action&.id
    update_id = update_action&.id

    SecurityRole.all.each do |role|
      # Get for all security roles
      Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: get_id })

      # Update for some roles
      if role.description == 'Administrator' || role.description == 'Underwriting Manager' || role.description == 'Underwriting User' ||
         role.description == 'Verification Manager' || role.description == 'Verification User'
        Permission.create({ security_role_id: role.id, resource_id: resource_id, action_id: update_id })
      end
    end
  end
end
