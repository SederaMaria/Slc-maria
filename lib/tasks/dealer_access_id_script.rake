namespace :dealer_access_id do
    desc "Updating Dealer Access ID's"
    task update: :environment do
      access.each do |dealer|
        Dealership.where(id: dealer[0]).update(access_id: dealer[1])
        p dealer
  end
end

def access
  xlsx = Roo::Spreadsheet.open('db/dealer-access_id.xlsx', extension: :xlsx)
  a = []
  b = 0
  ids = xlsx.column(1)
  access_id = xlsx.column(4)
  
  ids.each do |id|
    a << [id,access_id[b]]
    b += 1
  end
  return a.drop(1)
 end
end
  