namespace :model_groups do
  # bundle exec rake model_groups:update_maximum_term_length_per_year
  desc "Task description"
  task update_maximum_term_length_per_year: :environment do
    # XL/XR/XG
    ModelYear.where("name LIKE 'XL%' OR name LIKE 'XR%' OR name LIKE 'XG%'").where(year: 2010..2021).update_all(maximum_term_length: 36)
    ModelYear.where("name LIKE 'XL%' OR name LIKE 'XR%' OR name LIKE 'XG%'").where(year: 2007..2009).update_all(maximum_term_length: 24)

    # Dyna/VRSC
    if dyna = ModelGroup.where("name LIKE '%Dyna%'").first
      dyna.update(maximum_term_length: 48, maximum_term_length_per_year: { 2010 => 36, 2009 => 24, 2008 => 24, 2007 => 24 })
    end
    if vrsc = ModelGroup.where("name LIKE '%VRSC%'").first
      vrsc.update(maximum_term_length: 48, maximum_term_length_per_year: { 2010 => 36, 2009 => 24, 2008 => 24, 2007 => 24 })
    end

    # Softail/Touring
    if softail = ModelGroup.where("name LIKE '%Softail%'").first
      softail.update(maximum_term_length: 60, maximum_term_length_per_year: { 2010 => 48, 2009 => 36, 2008 => 24, 2007 => 24 })
    end
    if touring = ModelGroup.where("name LIKE '%Touring%'").first
      touring.update(maximum_term_length: 60, maximum_term_length_per_year: { 2010 => 48, 2009 => 36, 2008 => 24, 2007 => 24 })
    end

    # All Indians
    if chief = ModelGroup.where("name LIKE '%Chief%'").first
      chief.update(maximum_term_length: 48)
    end
    if scout = ModelGroup.where("name LIKE '%Scout%'").first
      scout.update(maximum_term_length: 48)
    end
    if sportbikes = ModelGroup.where("name LIKE '%Sportbikes%'").first
      sportbikes.update(maximum_term_length: 48)
    end
  end
end
