namespace :employment_status do
  desc "Seed Employment status index and definitions"
  task seed: :environment do
    unless EmploymentStatus.all.size > 0
      EmploymentStatus.create(employment_status_index: 0, definition: "employed")
      EmploymentStatus.create(employment_status_index: 1, definition: "self_employed")
      EmploymentStatus.create(employment_status_index: 2, definition: "soc_sec")
      EmploymentStatus.create(employment_status_index: 3, definition: "unemployed")
      EmploymentStatus.create(employment_status_index: 4, definition: "disabled")
      EmploymentStatus.create(employment_status_index: 5, definition: "retired")
    end
  end
end