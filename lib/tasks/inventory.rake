namespace :inventory do
    desc 'Seed inventory statuses'
    task seed_status: :environment do
      if InventoryStatus.all.empty?
        inventory_status_seed.each do |seed|
          InventoryStatus.create(seed)
        end
      end
      
    end
    
    def inventory_status_seed
      [
        { active: true,	description: "For Sale" },
        { active: true,	description: "Sold" },
        { active: true,	description: "Staging" }
      ]
    end
  
  end
  