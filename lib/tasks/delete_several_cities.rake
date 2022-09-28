namespace :delete_several_cities_167494821 do
  desc 'Delete several cities'
  task delete: :environment do
      City.where(id: [ 
                      15782,
                      16474,
                      16339,
                      16274,
                      16147,
                      16170,
                      16073,
                      15977,
                      16075,
                      15851,
                      15899,
                      16301,
                      15852,
                      15829,
                      15889,
                      15905,
                      15906,
                      15907,
                      15908,
                      16229,
                      15868,
                      16327,
                      16270,
                      15934,
                      16245,
                      16372 
                      ]).delete_all
  end
end
