namespace :relationship_to_lessee do
  desc 'Seed Relatinship to Lessee'
  task seed: :environment do
    if RelationshipToLessee.all.empty?
      relationships.each do |r|
        RelationshipToLessee.create(r)
      end
    end
  end

  private

  def relationships
    [
      { description: 'Son' },
      { description: 'Daughter' },
      { description: 'Father' },
      { description: 'Brother' },
      { description: 'Colleague' },
      { description: 'Other' }

    ]
  end
end
