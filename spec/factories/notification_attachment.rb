FactoryBot.define do
  factory :notification_attachment do
     description { 'A credit report for Jane' }
     upload { File.open("#{Rails.root}/spec/data/merge-report.pdf") }
  end
end
