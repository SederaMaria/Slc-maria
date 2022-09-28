namespace :actions do
  desc 'Seed Actions'
  task seed: :environment do
    if Action.all.empty?
      action_seed.each do |seed|
        Action.create(seed)
      end
    end
  end

  def action_seed
    [
      { rights: 'create' },
      { rights: 'delete' },
      { rights: 'get' },
      { rights: 'update' }
    ]
  end
end
