namespace :dealer_county do
    desc 'update address counties'
    task import: :environment do
    address_ids.each do |address|
      Address.where(id: address[0]).update(county: address[1])
      p address
      end
    end

  def address_ids
    xlsx = Roo::Spreadsheet.open('db/dealer_counties.xlsx', extension: :xlsx)

      a = []
      b = 0
      ids = xlsx.column(1)
      address_ids = xlsx.column(2)

      ids.each do |x|
        a << [x,address_ids[b]]
        b += 1
      end
      return a.drop(1)
      

  end
  end
  
