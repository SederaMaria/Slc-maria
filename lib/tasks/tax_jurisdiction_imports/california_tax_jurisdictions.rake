namespace :tax_jurisdictions do
  namespace :california do
    desc 'Clear California Tax Jurisdictions and Rules'
    task clear: :environment do
      TaxJurisdiction.in_california.delete_all
    end

    desc 'Import/Update California Tax Jurisdictions and Rules'
    task import: :environment do
      CSV.parse(california_data, headers: true) do |row|
        find_or_create_california_county_tax_rule(row)
        find_or_create_california_tax_jurisdiction(row)
      end
    end

    def find_or_create_california_tax_jurisdiction(california_data)
      name            = california_data['County'] + ' - ' + california_data['Location']
      us_state        = 'california'
      state_tax_rule  = california_state_rule(california_data)
      county_tax_rule = find_or_create_california_county_tax_rule(california_data)
      local_tax_rule  = find_or_create_california_local_tax_rule(california_data)

      TaxJurisdiction.where(name: name, us_state: us_state).first_or_create(
          state_tax_rule:  state_tax_rule,
          county_tax_rule: county_tax_rule,
          local_tax_rule: local_tax_rule,
          )
    end

    def find_or_create_california_county_tax_rule(california_data)
      county_name              = "CALIFORNIA COUNTY #{california_data['County']}"
      sales_tax_percentage     = california_data['CountyRate'].to_f
      up_front_tax_percentage  = california_data['CountyRate'].to_f
      cash_down_tax_percentage = california_data['CountyRate'].to_f

      puts ("Setting Rates for #{county_name}:  (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.county.where(name: county_name).first_or_create(
          sales_tax_percentage:     sales_tax_percentage,
          up_front_tax_percentage:  up_front_tax_percentage,
          cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_california_local_tax_rule(california_data)
      city_name                = "CALIFORNIA LOCAL #{california_data['Location']} "
      sales_tax_percentage     = california_data['CityRate'].to_f
      up_front_tax_percentage  = california_data['CitRate'].to_f
      cash_down_tax_percentage = california_data['CityRate'].to_f

      puts ("Setting Rates for #{city_name}:  (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.local.where(name: city_name).first_or_create(
          sales_tax_percentage:     sales_tax_percentage,
          up_front_tax_percentage:  up_front_tax_percentage,
          cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def california_state_rule(california_data)
      puts 'Importing State Tax Rules...'
      @california_state_rule ||= TaxRule.state.where(name: 'California').first_or_create(
          sales_tax_percentage:     california_data['StateRate'].to_f,
          up_front_tax_percentage:  california_data['StateRate'].to_f,
          cash_down_tax_percentage: california_data['StateRate'].to_f,
          )
    end

    def california_data
      <<-CSV
Location,StateRate,CombinedRate,CountyRate,CityRate,County
Alameda,7.250%,9.250%,2.000%,0.000%,Alameda
Albany,7.250%,9.750%,2.000%,0.500%,Alameda
Army Terminal,7.250%,9.250%,2.000%,0.000%,Alameda
Ashlan,7.250%,9.250%,2.000%,0.000%,Alameda
Berkeley,7.250%,9.250%,2.000%,0.000%,Alameda
Bradford,7.250%,9.250%,2.000%,0.000%,Alameda
Castro Valley,7.250%,9.250%,2.000%,0.000%,Alameda
Cresta Blanca,7.250%,9.250%,2.000%,0.000%,Alameda
Dublin,7.250%,9.250%,2.000%,0.000%,Alameda
Elmwood,7.250%,9.250%,2.000%,0.000%,Alameda
Emeryville,7.250%,9.250%,2.000%,0.000%,Alameda
Fremont,7.250%,9.250%,2.000%,0.000%,Alameda
Government Island,7.250%,9.250%,2.000%,0.000%,Alameda
Hayward,7.250%,9.750%,2.000%,0.500%,Alameda
Heyer,7.250%,9.250%,2.000%,0.000%,Alameda
Landscape,7.250%,9.250%,2.000%,0.000%,Alameda
Livermore,7.250%,9.250%,2.000%,0.000%,Alameda
Naval Air Station(Alameda),7.250%,9.250%,2.000%,0.000%,Alameda
Naval Hospital(Oakland),7.250%,9.250%,2.000%,0.000%,Alameda
Naval Supply Center(Oakland),7.250%,9.250%,2.000%,0.000%,Alameda
Newark,7.250%,9.750%,2.000%,0.500%,Alameda
Oakland,7.250%,9.250%,2.000%,0.000%,Alameda
Piedmont,7.250%,9.250%,2.000%,0.000%,Alameda
Pleasanton,7.250%,9.250%,2.000%,0.000%,Alameda
San Leandro,7.250%,9.750%,2.000%,0.500%,Alameda
San Lorenzo,7.250%,9.250%,2.000%,0.000%,Alameda
South Shore(Alameda),7.250%,9.250%,2.000%,0.000%,Alameda
Sunol,7.250%,9.250%,2.000%,0.000%,Alameda
Union City,7.250%,9.750%,2.000%,0.500%,Alameda
Warm Springs(Fremont),7.250%,9.250%,2.000%,0.000%,Alameda
Bear Valley,7.250%,7.250%,0.000%,0.000%,Alpine
Hope Valley(Forest Camp),7.250%,7.250%,0.000%,0.000%,Alpine
Kirkwood,7.250%,7.250%,0.000%,0.000%,Alpine
Lake Alpine,7.250%,7.250%,0.000%,0.000%,Alpine
Markleeville,7.250%,7.250%,0.000%,0.000%,Alpine
Woodfords,7.250%,7.250%,0.000%,0.000%,Alpine
Amador City,7.250%,7.750%,0.500%,0.000%,Amador
Bear River Lake,7.250%,7.750%,0.500%,0.000%,Amador
Drytown,7.250%,7.750%,0.500%,0.000%,Amador
Fiddletown,7.250%,7.750%,0.500%,0.000%,Amador
Ione,7.250%,7.750%,0.500%,0.000%,Amador
Jackson,7.250%,7.750%,0.500%,0.000%,Amador
Kit Carson,7.250%,7.750%,0.500%,0.000%,Amador
Martell,7.250%,7.750%,0.500%,0.000%,Amador
Pine Grove,7.250%,7.750%,0.500%,0.000%,Amador
Pioneer,7.250%,7.750%,0.500%,0.000%,Amador
Plymouth,7.250%,7.750%,0.500%,0.000%,Amador
River Pines,7.250%,7.750%,0.500%,0.000%,Amador
Silver Lake,7.250%,7.750%,0.500%,0.000%,Amador
Sutter Creek,7.250%,7.750%,0.500%,0.000%,Amador
Volcano,7.250%,7.750%,0.500%,0.000%,Amador
Bangor,7.250%,7.250%,0.000%,0.000%,Butte
Berry Creek,7.250%,7.250%,0.000%,0.000%,Butte
Biggs,7.250%,7.250%,0.000%,0.000%,Butte
Butte Meadows,7.250%,7.250%,0.000%,0.000%,Butte
Chico,7.250%,7.250%,0.000%,0.000%,Butte
Clipper Mills,7.250%,7.250%,0.000%,0.000%,Butte
Cohasset,7.250%,7.250%,0.000%,0.000%,Butte
Durham,7.250%,7.250%,0.000%,0.000%,Butte
Feather Falls,7.250%,7.250%,0.000%,0.000%,Butte
Forbestown,7.250%,7.250%,0.000%,0.000%,Butte
Forest Ranch,7.250%,7.250%,0.000%,0.000%,Butte
Gridley,7.250%,7.250%,0.000%,0.000%,Butte
Magalia,7.250%,7.250%,0.000%,0.000%,Butte
Nelson,7.250%,7.250%,0.000%,0.000%,Butte
Oroville,7.250%,7.250%,0.000%,0.000%,Butte
Palermo,7.250%,7.250%,0.000%,0.000%,Butte
Paradise,7.250%,7.750%,0.000%,0.500%,Butte
Pulga,7.250%,7.250%,0.000%,0.000%,Butte
Richardson Springs,7.250%,7.250%,0.000%,0.000%,Butte
Richvale,7.250%,7.250%,0.000%,0.000%,Butte
Stirling City,7.250%,7.250%,0.000%,0.000%,Butte
Yankee Hill,7.250%,7.250%,0.000%,0.000%,Butte
Altaville,7.250%,7.250%,0.000%,0.000%,Calaveras
Angels Camp,7.250%,7.250%,0.000%,0.000%,Calaveras
Arnold,7.250%,7.250%,0.000%,0.000%,Calaveras
Avery,7.250%,7.250%,0.000%,0.000%,Calaveras
Burson,7.250%,7.250%,0.000%,0.000%,Calaveras
Camp Connell,7.250%,7.250%,0.000%,0.000%,Calaveras
Campo Seco,7.250%,7.250%,0.000%,0.000%,Calaveras
Copperopolis,7.250%,7.250%,0.000%,0.000%,Calaveras
Douglas Flat,7.250%,7.250%,0.000%,0.000%,Calaveras
Glencoe,7.250%,7.250%,0.000%,0.000%,Calaveras
Hathaway Pines,7.250%,7.250%,0.000%,0.000%,Calaveras
Mokelumne Hill,7.250%,7.250%,0.000%,0.000%,Calaveras
Mountain Ranch,7.250%,7.250%,0.000%,0.000%,Calaveras
Murphys,7.250%,7.250%,0.000%,0.000%,Calaveras
Rail Road Flat,7.250%,7.250%,0.000%,0.000%,Calaveras
San Andreas,7.250%,7.250%,0.000%,0.000%,Calaveras
Sheepranch,7.250%,7.250%,0.000%,0.000%,Calaveras
Vallecito,7.250%,7.250%,0.000%,0.000%,Calaveras
Valley Springs,7.250%,7.250%,0.000%,0.000%,Calaveras
Wallace,7.250%,7.250%,0.000%,0.000%,Calaveras
West Point,7.250%,7.250%,0.000%,0.000%,Calaveras
White Pines,7.250%,7.250%,0.000%,0.000%,Calaveras
Wilseyville,7.250%,7.250%,0.000%,0.000%,Calaveras
Arbuckle,7.250%,7.250%,0.000%,0.000%,Colusa
College City,7.250%,7.250%,0.000%,0.000%,Colusa
Colusa,7.250%,7.250%,0.000%,0.000%,Colusa
Deleven,7.250%,7.250%,0.000%,0.000%,Colusa
Grimes,7.250%,7.250%,0.000%,0.000%,Colusa
Maxwell,7.250%,7.250%,0.000%,0.000%,Colusa
Princeton,7.250%,7.250%,0.000%,0.000%,Colusa
Sites,7.250%,7.250%,0.000%,0.000%,Colusa
Stonyford,7.250%,7.250%,0.000%,0.000%,Colusa
Williams,7.250%,7.750%,0.000%,0.500%,Colusa
Alamo,7.250%,8.250%,1.000%,0.000%,Contra Costa
Antioch,7.250%,8.750%,1.000%,0.500%,Contra Costa
Bay Point(formally West Pittsburg),7.250%,8.250%,1.000%,0.000%,Contra Costa
Bethel Island,7.250%,8.250%,1.000%,0.000%,Contra Costa
Black Hawk,7.250%,8.250%,1.000%,0.000%,Contra Costa
Brentwood,7.250%,8.250%,1.000%,0.000%,Contra Costa
Byron,7.250%,8.250%,1.000%,0.000%,Contra Costa
Canyon,7.250%,8.250%,1.000%,0.000%,Contra Costa
Clayton,7.250%,8.250%,1.000%,0.000%,Contra Costa
Concord,7.250%,8.750%,1.000%,0.500%,Contra Costa
Crockett,7.250%,8.250%,1.000%,0.000%,Contra Costa
Danville,7.250%,8.250%,1.000%,0.000%,Contra Costa
Diablo,7.250%,8.250%,1.000%,0.000%,Contra Costa
Discovery Bay,7.250%,8.250%,1.000%,0.000%,Contra Costa
Dollar Ranch,7.250%,8.250%,1.000%,0.000%,Contra Costa
El Cerrito,7.250%,9.750%,1.000%,1.500%,Contra Costa
El Sobrante,7.250%,8.250%,1.000%,0.000%,Contra Costa
Fairmount,7.250%,8.250%,1.000%,0.000%,Contra Costa
Hercules,7.250%,8.750%,1.000%,0.500%,Contra Costa
Kensington,7.250%,8.250%,1.000%,0.000%,Contra Costa
Knightsen,7.250%,8.250%,1.000%,0.000%,Contra Costa
Lafayette,7.250%,8.250%,1.000%,0.000%,Contra Costa
Martinez,7.250%,8.750%,1.000%,0.500%,Contra Costa
Mira Vista,7.250%,8.250%,1.000%,0.000%,Contra Costa
Moraga,7.250%,9.250%,1.000%,1.000%,Contra Costa
Oakley,7.250%,8.250%,1.000%,0.000%,Contra Costa
Orinda,7.250%,8.750%,1.000%,0.500%,Contra Costa
Pacheco,7.250%,8.250%,1.000%,0.000%,Contra Costa
Pinole,7.250%,9.250%,1.000%,1.000%,Contra Costa
Pittsburg,7.250%,8.750%,1.000%,0.500%,Contra Costa
Pleasant Hill,7.250%,8.750%,1.000%,0.500%,Contra Costa
Port Costa,7.250%,8.250%,1.000%,0.000%,Contra Costa
Rheem Valley(Moraga),7.250%,9.250%,1.000%,1.000%,Contra Costa
Richmond,7.250%,9.250%,1.000%,1.000%,Contra Costa
Rodeo,7.250%,8.250%,1.000%,0.000%,Contra Costa
San Pablo,7.250%,8.750%,1.000%,0.500%,Contra Costa
San Ramon,7.250%,8.250%,1.000%,0.000%,Contra Costa
Selby,7.250%,8.250%,1.000%,0.000%,Contra Costa
Shore Acres,7.250%,8.250%,1.000%,0.000%,Contra Costa
Walnut Creek,7.250%,8.250%,1.000%,0.000%,Contra Costa
Crescent City,7.250%,7.500%,0.250%,0.000%,Del Norte
Fort Dick,7.250%,7.500%,0.250%,0.000%,Del Norte
Gasquet,7.250%,7.500%,0.250%,0.000%,Del Norte
Klamath,7.250%,7.500%,0.250%,0.000%,Del Norte
Requa,7.250%,7.500%,0.250%,0.000%,Del Norte
Smith River,7.250%,7.500%,0.250%,0.000%,Del Norte
Al Tahoe,7.250%,7.250%,0.000%,0.000%,El Dorado
Bijou,7.250%,7.250%,0.000%,0.000%,El Dorado
Cameron Park,7.250%,7.250%,0.000%,0.000%,El Dorado
Camino,7.250%,7.250%,0.000%,0.000%,El Dorado
Coloma,7.250%,7.250%,0.000%,0.000%,El Dorado
Cool,7.250%,7.250%,0.000%,0.000%,El Dorado
Diamond Springs,7.250%,7.250%,0.000%,0.000%,El Dorado
Echo Lake,7.250%,7.250%,0.000%,0.000%,El Dorado
El Dorado,7.250%,7.250%,0.000%,0.000%,El Dorado
El Dorado Hills,7.250%,7.250%,0.000%,0.000%,El Dorado
Fallen Leaf,7.250%,7.250%,0.000%,0.000%,El Dorado
Garden Valley,7.250%,7.250%,0.000%,0.000%,El Dorado
Georgetown,7.250%,7.250%,0.000%,0.000%,El Dorado
Greenwood,7.250%,7.250%,0.000%,0.000%,El Dorado
Grizzly Flats,7.250%,7.250%,0.000%,0.000%,El Dorado
Kelsey,7.250%,7.250%,0.000%,0.000%,El Dorado
Kyburz,7.250%,7.250%,0.000%,0.000%,El Dorado
Little Norway,7.250%,7.250%,0.000%,0.000%,El Dorado
Lotus,7.250%,7.250%,0.000%,0.000%,El Dorado
Meeks Bay,7.250%,7.250%,0.000%,0.000%,El Dorado
Meyers,7.250%,7.250%,0.000%,0.000%,El Dorado
Mt. Aukum,7.250%,7.250%,0.000%,0.000%,El Dorado
Nashville,7.250%,7.250%,0.000%,0.000%,El Dorado
Omo Ranch,7.250%,7.250%,0.000%,0.000%,El Dorado
Pacific House,7.250%,7.250%,0.000%,0.000%,El Dorado
Pilot Hill,7.250%,7.250%,0.000%,0.000%,El Dorado
Placerville,7.250%,8.250%,0.000%,1.000%,El Dorado
Pollock Pines,7.250%,7.250%,0.000%,0.000%,El Dorado
Rescue,7.250%,7.250%,0.000%,0.000%,El Dorado
Shingle Springs,7.250%,7.250%,0.000%,0.000%,El Dorado
Smithflat,7.250%,7.250%,0.000%,0.000%,El Dorado
Somerset,7.250%,7.250%,0.000%,0.000%,El Dorado
South Lake Tahoe,7.250%,7.750%,0.000%,0.500%,El Dorado
Tahoe Paradise,7.250%,7.250%,0.000%,0.000%,El Dorado
Tahoe Valley,7.250%,7.250%,0.000%,0.000%,El Dorado
Twin Bridges,7.250%,7.250%,0.000%,0.000%,El Dorado
Auberry,7.250%,7.975%,0.725%,0.000%,Fresno
Barton,7.250%,7.975%,0.725%,0.000%,Fresno
Big Creek,7.250%,7.975%,0.725%,0.000%,Fresno
Biola,7.250%,7.975%,0.725%,0.000%,Fresno
Burrel,7.250%,7.975%,0.725%,0.000%,Fresno
Calwa,7.250%,7.975%,0.725%,0.000%,Fresno
Cantua Creek,7.250%,7.975%,0.725%,0.000%,Fresno
Cardwell,7.250%,7.975%,0.725%,0.000%,Fresno
Caruthers,7.250%,7.975%,0.725%,0.000%,Fresno
Cedar Crest,7.250%,7.975%,0.725%,0.000%,Fresno
Clinter,7.250%,7.975%,0.725%,0.000%,Fresno
Clovis,7.250%,7.975%,0.725%,0.000%,Fresno
Coalinga,7.250%,7.975%,0.725%,0.000%,Fresno
Del Rey,7.250%,7.975%,0.725%,0.000%,Fresno
Dinkey Creek,7.250%,7.975%,0.725%,0.000%,Fresno
Dunlap,7.250%,7.975%,0.725%,0.000%,Fresno
Easton,7.250%,7.975%,0.725%,0.000%,Fresno
Fancher,7.250%,7.975%,0.725%,0.000%,Fresno
Fig Garden Village(Fresno),7.250%,7.975%,0.725%,0.000%,Fresno
Firebaugh,7.250%,7.975%,0.725%,0.000%,Fresno
Five Points,7.250%,7.975%,0.725%,0.000%,Fresno
Fowler,7.250%,7.975%,0.725%,0.000%,Fresno
Fresno,7.250%,7.975%,0.725%,0.000%,Fresno
Friant,7.250%,7.975%,0.725%,0.000%,Fresno
Helm,7.250%,7.975%,0.725%,0.000%,Fresno
Herndon,7.250%,7.975%,0.725%,0.000%,Fresno
Highway City(Fresno),7.250%,7.975%,0.725%,0.000%,Fresno
Hume,7.250%,7.975%,0.725%,0.000%,Fresno
Huntington Lake,7.250%,7.975%,0.725%,0.000%,Fresno
Huron,7.250%,8.975%,0.725%,1.000%,Fresno
Kerman,7.250%,7.975%,0.725%,0.000%,Fresno
Kingsburg,7.250%,8.975%,0.725%,1.000%,Fresno
Lakeshore,7.250%,7.975%,0.725%,0.000%,Fresno
Laton,7.250%,7.975%,0.725%,0.000%,Fresno
Malaga,7.250%,7.975%,0.725%,0.000%,Fresno
Mendota,7.250%,7.975%,0.725%,0.000%,Fresno
Miramonte,7.250%,7.975%,0.725%,0.000%,Fresno
Mono Hot Springs,7.250%,7.975%,0.725%,0.000%,Fresno
Orange Cove,7.250%,7.975%,0.725%,0.000%,Fresno
Parlier,7.250%,7.975%,0.725%,0.000%,Fresno
Piedra,7.250%,7.975%,0.725%,0.000%,Fresno
Pinedale(Fresno),7.250%,7.975%,0.725%,0.000%,Fresno
Prather,7.250%,7.975%,0.725%,0.000%,Fresno
Raisin City,7.250%,7.975%,0.725%,0.000%,Fresno
Reedley,7.250%,8.475%,0.725%,0.500%,Fresno
Riverdale,7.250%,7.975%,0.725%,0.000%,Fresno
San Joaquin,7.250%,7.975%,0.725%,0.000%,Fresno
Sanger,7.250%,8.725%,0.725%,0.750%,Fresno
Selma,7.250%,8.475%,0.725%,0.500%,Fresno
Shaver Lake,7.250%,7.975%,0.725%,0.000%,Fresno
Squaw Valley,7.250%,7.975%,0.725%,0.000%,Fresno
Tollhouse,7.250%,7.975%,0.725%,0.000%,Fresno
Tranquillity,7.250%,7.975%,0.725%,0.000%,Fresno
Artois,7.250%,7.250%,0.000%,0.000%,Glenn
Butte City,7.250%,7.250%,0.000%,0.000%,Glenn
Elk Creek,7.250%,7.250%,0.000%,0.000%,Glenn
Glenn,7.250%,7.250%,0.000%,0.000%,Glenn
Hamilton City,7.250%,7.250%,0.000%,0.000%,Glenn
Ordbend,7.250%,7.250%,0.000%,0.000%,Glenn
Orland,7.250%,7.750%,0.000%,0.500%,Glenn
Willows,7.250%,7.250%,0.000%,0.000%,Glenn
Alderpoint,7.250%,7.750%,0.500%,0.000%,Humboldt
Alton,7.250%,7.750%,0.500%,0.000%,Humboldt
Arcata,7.250%,8.500%,0.500%,0.750%,Humboldt
Bayside,7.250%,7.750%,0.500%,0.000%,Humboldt
Blocksburg,7.250%,7.750%,0.500%,0.000%,Humboldt
Blue Lake,7.250%,7.750%,0.500%,0.000%,Humboldt
Briceland,7.250%,7.750%,0.500%,0.000%,Humboldt
Bridgeville,7.250%,7.750%,0.500%,0.000%,Humboldt
Carlotta,7.250%,7.750%,0.500%,0.000%,Humboldt
Crannell,7.250%,7.750%,0.500%,0.000%,Humboldt
Cutten,7.250%,7.750%,0.500%,0.000%,Humboldt
Ettersburg,7.250%,7.750%,0.500%,0.000%,Humboldt
Eureka,7.250%,8.500%,0.500%,0.750%,Humboldt
Fernbridge(Fortuna),7.250%,7.750%,0.500%,0.000%,Humboldt
Ferndale,7.250%,7.750%,0.500%,0.000%,Humboldt
Fields Landing,7.250%,7.750%,0.500%,0.000%,Humboldt
Fort Seward,7.250%,7.750%,0.500%,0.000%,Humboldt
Fortuna,7.250%,8.500%,0.500%,0.750%,Humboldt
Freshwater,7.250%,7.750%,0.500%,0.000%,Humboldt
Garberville,7.250%,7.750%,0.500%,0.000%,Humboldt
Harris,7.250%,7.750%,0.500%,0.000%,Humboldt
Holmes,7.250%,7.750%,0.500%,0.000%,Humboldt
Honeydew,7.250%,7.750%,0.500%,0.000%,Humboldt
Hoopa,7.250%,7.750%,0.500%,0.000%,Humboldt
Hydesville,7.250%,7.750%,0.500%,0.000%,Humboldt
Kneeland,7.250%,7.750%,0.500%,0.000%,Humboldt
Korbel,7.250%,7.750%,0.500%,0.000%,Humboldt
Loleta,7.250%,7.750%,0.500%,0.000%,Humboldt
McKinleyville,7.250%,7.750%,0.500%,0.000%,Humboldt
Miranda,7.250%,7.750%,0.500%,0.000%,Humboldt
Myers Flat,7.250%,7.750%,0.500%,0.000%,Humboldt
Orick,7.250%,7.750%,0.500%,0.000%,Humboldt
Orleans,7.250%,7.750%,0.500%,0.000%,Humboldt
Pepperwood,7.250%,7.750%,0.500%,0.000%,Humboldt
Petrolia,7.250%,7.750%,0.500%,0.000%,Humboldt
Phillipsville,7.250%,7.750%,0.500%,0.000%,Humboldt
Redcrest,7.250%,7.750%,0.500%,0.000%,Humboldt
Redway,7.250%,7.750%,0.500%,0.000%,Humboldt
Richardson Grove,7.250%,7.750%,0.500%,0.000%,Humboldt
Rio Dell,7.250%,8.750%,0.500%,1.000%,Humboldt
Rohnerville,7.250%,7.750%,0.500%,0.000%,Humboldt
Ruby Valley,7.250%,7.750%,0.500%,0.000%,Humboldt
Samoa,7.250%,7.750%,0.500%,0.000%,Humboldt
Scotia,7.250%,7.750%,0.500%,0.000%,Humboldt
Shively,7.250%,7.750%,0.500%,0.000%,Humboldt
South Fork,7.250%,7.750%,0.500%,0.000%,Humboldt
Trinidad,7.250%,8.500%,0.500%,0.750%,Humboldt
Weott,7.250%,7.750%,0.500%,0.000%,Humboldt
Westhaven,7.250%,7.750%,0.500%,0.000%,Humboldt
Whitethorn,7.250%,7.750%,0.500%,0.000%,Humboldt
Whitlow,7.250%,7.750%,0.500%,0.000%,Humboldt
Willow Creek,7.250%,7.750%,0.500%,0.000%,Humboldt
Bard,7.250%,7.750%,0.500%,0.000%,Imperial
Bombay Beach,7.250%,7.750%,0.500%,0.000%,Imperial
Brawley,7.250%,7.750%,0.500%,0.000%,Imperial
Calexico,7.250%,8.250%,0.500%,0.500%,Imperial
Calipatria,7.250%,7.750%,0.500%,0.000%,Imperial
El Centro,7.250%,8.250%,0.500%,0.500%,Imperial
Heber,7.250%,7.750%,0.500%,0.000%,Imperial
Holtville,7.250%,7.750%,0.500%,0.000%,Imperial
Imperial,7.250%,7.750%,0.500%,0.000%,Imperial
Niland,7.250%,7.750%,0.500%,0.000%,Imperial
Ocotillo,7.250%,7.750%,0.500%,0.000%,Imperial
Palo Verde,7.250%,7.750%,0.500%,0.000%,Imperial
Plaster City,7.250%,7.750%,0.500%,0.000%,Imperial
Salton City,7.250%,7.750%,0.500%,0.000%,Imperial
Seeley,7.250%,7.750%,0.500%,0.000%,Imperial
Westmorland,7.250%,7.750%,0.500%,0.000%,Imperial
Winterhaven,7.250%,7.750%,0.500%,0.000%,Imperial
Amargosa(Death Valley),7.250%,7.750%,0.500%,0.000%,Inyo
Bartlett,7.250%,7.750%,0.500%,0.000%,Inyo
Big Pine,7.250%,7.750%,0.500%,0.000%,Inyo
Bishop,7.250%,7.750%,0.500%,0.000%,Inyo
Cartago,7.250%,7.750%,0.500%,0.000%,Inyo
Coso Junction,7.250%,7.750%,0.500%,0.000%,Inyo
Darwin,7.250%,7.750%,0.500%,0.000%,Inyo
Death Valley,7.250%,7.750%,0.500%,0.000%,Inyo
Death Valley Junction,7.250%,7.750%,0.500%,0.000%,Inyo
Independence,7.250%,7.750%,0.500%,0.000%,Inyo
Inyo,7.250%,7.750%,0.500%,0.000%,Inyo
Keeler,7.250%,7.750%,0.500%,0.000%,Inyo
Laws,7.250%,7.750%,0.500%,0.000%,Inyo
Little Lake,7.250%,7.750%,0.500%,0.000%,Inyo
Lone Pine,7.250%,7.750%,0.500%,0.000%,Inyo
Olancha,7.250%,7.750%,0.500%,0.000%,Inyo
Shoshone,7.250%,7.750%,0.500%,0.000%,Inyo
Swall Meadows(Bishop),7.250%,7.750%,0.500%,0.000%,Inyo
Tecopa,7.250%,7.750%,0.500%,0.000%,Inyo
Arvin,7.250%,8.250%,0.000%,1.000%,Kern
Bakersfield,7.250%,7.250%,0.000%,0.000%,Kern
Bodfish,7.250%,7.250%,0.000%,0.000%,Kern
Boron,7.250%,7.250%,0.000%,0.000%,Kern
Buttonwillow,7.250%,7.250%,0.000%,0.000%,Kern
Caliente,7.250%,7.250%,0.000%,0.000%,Kern
California City,7.250%,7.250%,0.000%,0.000%,Kern
Cantil,7.250%,7.250%,0.000%,0.000%,Kern
China Lake NWC(Ridgecrest),7.250%,8.250%,0.000%,1.000%,Kern
Del Kern(Bakersfield),7.250%,7.250%,0.000%,0.000%,Kern
Delano,7.250%,8.250%,0.000%,1.000%,Kern
Di Giorgio,7.250%,7.250%,0.000%,0.000%,Kern
Edison,7.250%,7.250%,0.000%,0.000%,Kern
Edwards,7.250%,7.250%,0.000%,0.000%,Kern
Edwards A.F.B.,7.250%,7.250%,0.000%,0.000%,Kern
Fellows,7.250%,7.250%,0.000%,0.000%,Kern
Frazier Park,7.250%,7.250%,0.000%,0.000%,Kern
Glennville,7.250%,7.250%,0.000%,0.000%,Kern
Golden Hills,7.250%,7.250%,0.000%,0.000%,Kern
Greenacres,7.250%,7.250%,0.000%,0.000%,Kern
Homestead,7.250%,7.250%,0.000%,0.000%,Kern
Inyokern,7.250%,7.250%,0.000%,0.000%,Kern
Johannesburg,7.250%,7.250%,0.000%,0.000%,Kern
Keene,7.250%,7.250%,0.000%,0.000%,Kern
Kernville,7.250%,7.250%,0.000%,0.000%,Kern
La Cresta Village,7.250%,7.250%,0.000%,0.000%,Kern
Lake Isabella,7.250%,7.250%,0.000%,0.000%,Kern
Lamont,7.250%,7.250%,0.000%,0.000%,Kern
Lebec,7.250%,7.250%,0.000%,0.000%,Kern
Lost Hills,7.250%,7.250%,0.000%,0.000%,Kern
Maricopa,7.250%,7.250%,0.000%,0.000%,Kern
McFarland,7.250%,7.250%,0.000%,0.000%,Kern
McKittrick,7.250%,7.250%,0.000%,0.000%,Kern
Mettler,7.250%,7.250%,0.000%,0.000%,Kern
Miracle Hot Springs,7.250%,7.250%,0.000%,0.000%,Kern
Mojave,7.250%,7.250%,0.000%,0.000%,Kern
Monolith,7.250%,7.250%,0.000%,0.000%,Kern
Mountain Mesa,7.250%,7.250%,0.000%,0.000%,Kern
North Edwards,7.250%,7.250%,0.000%,0.000%,Kern
Oildale,7.250%,7.250%,0.000%,0.000%,Kern
Onyx,7.250%,7.250%,0.000%,0.000%,Kern
Pond,7.250%,7.250%,0.000%,0.000%,Kern
Pumpkin Center,7.250%,7.250%,0.000%,0.000%,Kern
Randsburg,7.250%,7.250%,0.000%,0.000%,Kern
Ridgecrest,7.250%,8.250%,0.000%,1.000%,Kern
Rio Bravo(Bakersfield),7.250%,7.250%,0.000%,0.000%,Kern
Rosamond,7.250%,7.250%,0.000%,0.000%,Kern
Shafter,7.250%,7.250%,0.000%,0.000%,Kern
Taft,7.250%,7.250%,0.000%,0.000%,Kern
Tehachapi,7.250%,7.250%,0.000%,0.000%,Kern
Tupman,7.250%,7.250%,0.000%,0.000%,Kern
Vista Park,7.250%,7.250%,0.000%,0.000%,Kern
Wasco,7.250%,8.250%,0.000%,1.000%,Kern
Weldon,7.250%,7.250%,0.000%,0.000%,Kern
Wheeler Ridge,7.250%,7.250%,0.000%,0.000%,Kern
Wofford Heights,7.250%,7.250%,0.000%,0.000%,Kern
Woody,7.250%,7.250%,0.000%,0.000%,Kern
Armona,7.250%,7.250%,0.000%,0.000%,Kings
Avenal,7.250%,7.250%,0.000%,0.000%,Kings
Corcoran,7.250%,8.250%,0.000%,1.000%,Kings
Hanford,7.250%,7.250%,0.000%,0.000%,Kings
Kettleman City,7.250%,7.250%,0.000%,0.000%,Kings
Lemoore,7.250%,7.250%,0.000%,0.000%,Kings
Naval Air Station(Lemoore),7.250%,7.250%,0.000%,0.000%,Kings
Stratford,7.250%,7.250%,0.000%,0.000%,Kings
Clearlake Highlands(Clearlake),7.250%,8.750%,0.000%,1.500%,Lake
Clearlake Oaks,7.250%,7.250%,0.000%,0.000%,Lake
Clearlake Park(Clearlake),7.250%,8.750%,0.000%,1.500%,Lake
Clearlake,7.250%,8.750%,0.000%,1.500%,Lake
Cobb,7.250%,7.250%,0.000%,0.000%,Lake
Finley,7.250%,7.250%,0.000%,0.000%,Lake
Glenhaven,7.250%,7.250%,0.000%,0.000%,Lake
Hobergs,7.250%,7.250%,0.000%,0.000%,Lake
Kelseyville,7.250%,7.250%,0.000%,0.000%,Lake
Lakeport,7.250%,8.750%,0.000%,1.500%,Lake
Loch Lomond,7.250%,7.250%,0.000%,0.000%,Lake
Lower Lake,7.250%,7.250%,0.000%,0.000%,Lake
Lucerne,7.250%,7.250%,0.000%,0.000%,Lake
Middletown,7.250%,7.250%,0.000%,0.000%,Lake
Nice,7.250%,7.250%,0.000%,0.000%,Lake
Upper Lake/Upper Lake Valley,7.250%,7.250%,0.000%,0.000%,Lake
Whispering Pines,7.250%,7.250%,0.000%,0.000%,Lake
Witter Springs,7.250%,7.250%,0.000%,0.000%,Lake
Bieber,7.250%,7.250%,0.000%,0.000%,Lassen
Doyle,7.250%,7.250%,0.000%,0.000%,Lassen
Herlong,7.250%,7.250%,0.000%,0.000%,Lassen
Horse Lake,7.250%,7.250%,0.000%,0.000%,Lassen
Janesville,7.250%,7.250%,0.000%,0.000%,Lassen
Johnstonville,7.250%,7.250%,0.000%,0.000%,Lassen
Juniper,7.250%,7.250%,0.000%,0.000%,Lassen
Litchfield,7.250%,7.250%,0.000%,0.000%,Lassen
Little Valley,7.250%,7.250%,0.000%,0.000%,Lassen
Madeline,7.250%,7.250%,0.000%,0.000%,Lassen
Milford,7.250%,7.250%,0.000%,0.000%,Lassen
Nubieber,7.250%,7.250%,0.000%,0.000%,Lassen
Ravendale,7.250%,7.250%,0.000%,0.000%,Lassen
Standish,7.250%,7.250%,0.000%,0.000%,Lassen
Susanville,7.250%,7.250%,0.000%,0.000%,Lassen
Termo,7.250%,7.250%,0.000%,0.000%,Lassen
Wendel,7.250%,7.250%,0.000%,0.000%,Lassen
Westwood,7.250%,7.250%,0.000%,0.000%,Lassen
Acton,7.250%,9.500%,1.250%,1.000%,Los Angeles
Agoura,7.250%,9.500%,1.250%,1.000%,Los Angeles
Agoura Hills,7.250%,9.500%,1.250%,1.000%,Los Angeles
Agua Dulce,7.250%,9.500%,1.250%,1.000%,Los Angeles
Alhambra,7.250%,9.500%,1.250%,1.000%,Los Angeles
Almondale,7.250%,9.500%,1.250%,1.000%,Los Angeles
Alondra,7.250%,9.500%,1.250%,1.000%,Los Angeles
Altadena,7.250%,9.500%,1.250%,1.000%,Los Angeles
Antelope Acres,7.250%,9.500%,1.250%,1.000%,Los Angeles
Arcadia,7.250%,9.500%,1.250%,1.000%,Los Angeles
Arleta(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Artesia,7.250%,9.500%,1.250%,1.000%,Los Angeles
Athens,7.250%,9.500%,1.250%,1.000%,Los Angeles
Avalon,7.250%,10.000%,1.250%,1.500%,Los Angeles
Azusa,7.250%,9.500%,1.250%,1.000%,Los Angeles
Bailey,7.250%,9.500%,1.250%,1.000%,Los Angeles
Baldwin Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Barrington,7.250%,9.500%,1.250%,1.000%,Los Angeles
Bassett,7.250%,9.500%,1.250%,1.000%,Los Angeles
Bel Air Estates(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Bell Gardens,7.250%,9.500%,1.250%,1.000%,Los Angeles
Bell,7.250%,9.500%,1.250%,1.000%,Los Angeles
Bellflower,7.250%,9.500%,1.250%,1.000%,Los Angeles
Beverly Hills,7.250%,9.500%,1.250%,1.000%,Los Angeles
Biola College(La Mirada),7.250%,9.500%,1.250%,1.000%,Los Angeles
Bouquet Canyon(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
Bradbury,7.250%,9.500%,1.250%,1.000%,Los Angeles
Brents Junction,7.250%,9.500%,1.250%,1.000%,Los Angeles
Brentwood(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Burbank,7.250%,9.500%,1.250%,1.000%,Los Angeles
Cabrillo,7.250%,9.500%,1.250%,1.000%,Los Angeles
Calabasas Highlands,7.250%,9.500%,1.250%,1.000%,Los Angeles
Calabasas Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Calabasas,7.250%,9.500%,1.250%,1.000%,Los Angeles
Canoga Annex,7.250%,9.500%,1.250%,1.000%,Los Angeles
Canoga Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Canyon Country(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
Carson,7.250%,9.500%,1.250%,1.000%,Los Angeles
Castaic,7.250%,9.500%,1.250%,1.000%,Los Angeles
Cedar,7.250%,9.500%,1.250%,1.000%,Los Angeles
Century City(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Cerritos,7.250%,9.500%,1.250%,1.000%,Los Angeles
Charter Oak,7.250%,9.500%,1.250%,1.000%,Los Angeles
Chatsworth(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
City of Commerce,7.250%,10.000%,1.250%,1.500%,Los Angeles
City of Industry,7.250%,9.500%,1.250%,1.000%,Los Angeles
City Terrace,7.250%,9.500%,1.250%,1.000%,Los Angeles
Claremont,7.250%,9.500%,1.250%,1.000%,Los Angeles
Cole,7.250%,9.500%,1.250%,1.000%,Los Angeles
Commerce,7.250%,10.000%,1.250%,1.500%,Los Angeles
Compton,7.250%,10.250%,1.250%,1.750%,Los Angeles
Cornell,7.250%,9.500%,1.250%,1.000%,Los Angeles
Covina,7.250%,9.500%,1.250%,1.000%,Los Angeles
Crenshaw(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Cudahy,7.250%,9.500%,1.250%,1.000%,Los Angeles
Culver City,7.250%,10.000%,1.250%,1.500%,Los Angeles
Del Sur,7.250%,9.500%,1.250%,1.000%,Los Angeles
Diamond Bar,7.250%,9.500%,1.250%,1.000%,Los Angeles
Downey,7.250%,10.000%,1.250%,1.500%,Los Angeles
Duarte,7.250%,9.500%,1.250%,1.000%,Los Angeles
Eagle Rock(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
East Los Angeles,7.250%,9.500%,1.250%,1.000%,Los Angeles
East Lynwood(Lynwood),7.250%,10.250%,1.250%,1.750%,Los Angeles
East Rancho Dominguez,7.250%,9.500%,1.250%,1.000%,Los Angeles
East San Pedro(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Eastgate,7.250%,9.500%,1.250%,1.000%,Los Angeles
Echo Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
El Monte,7.250%,10.000%,1.250%,1.500%,Los Angeles
El Segundo,7.250%,9.500%,1.250%,1.000%,Los Angeles
Elizabeth Lake,7.250%,9.500%,1.250%,1.000%,Los Angeles
Encino(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Flintridge(LaCanada/Flintridge),7.250%,9.500%,1.250%,1.000%,Los Angeles
Florence,7.250%,9.500%,1.250%,1.000%,Los Angeles
Forest Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Friendly Valley(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
Gardena,7.250%,9.500%,1.250%,1.000%,Los Angeles
Glassell Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Glendale,7.250%,9.500%,1.250%,1.000%,Los Angeles
Glendora,7.250%,9.500%,1.250%,1.000%,Los Angeles
Gorman,7.250%,9.500%,1.250%,1.000%,Los Angeles
Granada Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Green Valley,7.250%,9.500%,1.250%,1.000%,Los Angeles
Hacienda Heights,7.250%,9.500%,1.250%,1.000%,Los Angeles
Harbor City(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Hawaiian Gardens,7.250%,9.500%,1.250%,1.000%,Los Angeles
Hawthorne,7.250%,10.250%,1.250%,1.750%,Los Angeles
Hazard,7.250%,9.500%,1.250%,1.000%,Los Angeles
Hermosa Beach,7.250%,9.500%,1.250%,1.000%,Los Angeles
Hidden Hills,7.250%,9.500%,1.250%,1.000%,Los Angeles
Highland Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Hollywood(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Honby,7.250%,9.500%,1.250%,1.000%,Los Angeles
Huntington Park,7.250%,10.250%,1.250%,1.750%,Los Angeles
Hyde Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Industry,7.250%,9.500%,1.250%,1.000%,Los Angeles
Inglewood,7.250%,10.000%,1.250%,1.500%,Los Angeles
Irwindale,7.250%,9.500%,1.250%,1.000%,Los Angeles
Kagel Canyon,7.250%,9.500%,1.250%,1.000%,Los Angeles
L.A. Airport(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
La Canada-Flintridge,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Crescenta,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Habra Heights,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Mirada,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Puente,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Verne,7.250%,9.500%,1.250%,1.000%,Los Angeles
La Vina,7.250%,9.500%,1.250%,1.000%,Los Angeles
Ladera Heights,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lake Hughes,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lake Los Angeles,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lakeview Terrace(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Lakewood,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lancaster,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lang,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lawndale,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lennox,7.250%,9.500%,1.250%,1.000%,Los Angeles
Leona Valley,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lincoln Heights(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Littlerock(Also Little Rock),7.250%,9.500%,1.250%,1.000%,Los Angeles
Llano,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lomita,7.250%,9.500%,1.250%,1.000%,Los Angeles
Long Beach,7.250%,10.250%,1.250%,1.750%,Los Angeles
Longview,7.250%,9.500%,1.250%,1.000%,Los Angeles
Los Angeles,7.250%,9.500%,1.250%,1.000%,Los Angeles
Los Nietos,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lugo,7.250%,9.500%,1.250%,1.000%,Los Angeles
Lynwood,7.250%,10.250%,1.250%,1.750%,Los Angeles
Maclay,7.250%,9.500%,1.250%,1.000%,Los Angeles
Malibu,7.250%,9.500%,1.250%,1.000%,Los Angeles
Manhattan Beach,7.250%,9.500%,1.250%,1.000%,Los Angeles
Mar Vista,7.250%,9.500%,1.250%,1.000%,Los Angeles
Marcelina,7.250%,9.500%,1.250%,1.000%,Los Angeles
Marina Del Rey,7.250%,9.500%,1.250%,1.000%,Los Angeles
Maywood,7.250%,9.500%,1.250%,1.000%,Los Angeles
Mint Canyon,7.250%,9.500%,1.250%,1.000%,Los Angeles
Mission Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Moneta,7.250%,9.500%,1.250%,1.000%,Los Angeles
Monrovia,7.250%,9.500%,1.250%,1.000%,Los Angeles
Montebello,7.250%,9.500%,1.250%,1.000%,Los Angeles
Monterey Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Montrose,7.250%,9.500%,1.250%,1.000%,Los Angeles
Mount Wilson,7.250%,9.500%,1.250%,1.000%,Los Angeles
Naples,7.250%,9.500%,1.250%,1.000%,Los Angeles
Newhall(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
North Gardena,7.250%,9.500%,1.250%,1.000%,Los Angeles
North Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
North Hollywood(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Northridge(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Norwalk,7.250%,9.500%,1.250%,1.000%,Los Angeles
Oban,7.250%,9.500%,1.250%,1.000%,Los Angeles
Olive View(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pacific Palisades(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pacoima(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pallett,7.250%,9.500%,1.250%,1.000%,Los Angeles
Palmdale,7.250%,9.500%,1.250%,1.000%,Los Angeles
Palos Verdes Estates,7.250%,9.500%,1.250%,1.000%,Los Angeles
Palos Verdes/Peninsula,7.250%,9.500%,1.250%,1.000%,Los Angeles
Panorama City(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Paramount,7.250%,9.500%,1.250%,1.000%,Los Angeles
Pasadena,7.250%,9.500%,1.250%,1.000%,Los Angeles
Pearblossom,7.250%,9.500%,1.250%,1.000%,Los Angeles
Pearland,7.250%,9.500%,1.250%,1.000%,Los Angeles
Perry(Whittier),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pico Rivera,7.250%,10.250%,1.250%,1.750%,Los Angeles
Pinetree,7.250%,9.500%,1.250%,1.000%,Los Angeles
Playa Del Rey(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pomona,7.250%,9.500%,1.250%,1.000%,Los Angeles
Porter Ranch(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Portuguese Bend(Rancho Palos Verdes),7.250%,9.500%,1.250%,1.000%,Los Angeles
Pt. Dume,7.250%,9.500%,1.250%,1.000%,Los Angeles
Quartz Hill,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rancho Dominguez,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rancho Palos Verdes,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rancho Park(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Ravenna,7.250%,9.500%,1.250%,1.000%,Los Angeles
Redondo Beach,7.250%,9.500%,1.250%,1.000%,Los Angeles
Reseda(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Rimpau(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Rolling Hills Estates,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rolling Hills,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rose Bowl(Pasadena),7.250%,9.500%,1.250%,1.000%,Los Angeles
Rosemead,7.250%,9.500%,1.250%,1.000%,Los Angeles
Rowland Heights,7.250%,9.500%,1.250%,1.000%,Los Angeles
San Dimas,7.250%,9.500%,1.250%,1.000%,Los Angeles
San Fernando,7.250%,10.000%,1.250%,1.500%,Los Angeles
San Gabriel,7.250%,9.500%,1.250%,1.000%,Los Angeles
San Marino,7.250%,9.500%,1.250%,1.000%,Los Angeles
San Pedro(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Santa Clarita,7.250%,9.500%,1.250%,1.000%,Los Angeles
Santa Fe Springs,7.250%,9.500%,1.250%,1.000%,Los Angeles
Santa Monica,7.250%,10.250%,1.250%,1.750%,Los Angeles
Saugus(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sawtelle(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Seminole Hot Springs,7.250%,9.500%,1.250%,1.000%,Los Angeles
Sepulveda(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Shadow Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sherman Oaks(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sierra Madre,7.250%,9.500%,1.250%,1.000%,Los Angeles
Signal Hill,7.250%,9.500%,1.250%,1.000%,Los Angeles
Sleepy Valley,7.250%,9.500%,1.250%,1.000%,Los Angeles
Solemint,7.250%,9.500%,1.250%,1.000%,Los Angeles
South El Monte,7.250%,10.000%,1.250%,1.500%,Los Angeles
South Gate,7.250%,10.250%,1.250%,1.750%,Los Angeles
South Pasadena,7.250%,9.500%,1.250%,1.000%,Los Angeles
South Whittier,7.250%,9.500%,1.250%,1.000%,Los Angeles
Stevenson Ranch,7.250%,9.500%,1.250%,1.000%,Los Angeles
Studio City(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sulphur Springs,7.250%,9.500%,1.250%,1.000%,Los Angeles
Sun Valley(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sunland(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Sylmar(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Tarzana(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Temple City,7.250%,9.500%,1.250%,1.000%,Los Angeles
Terminal Island(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Toluca Lake(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Topanga,7.250%,9.500%,1.250%,1.000%,Los Angeles
Topanga Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Torrance,7.250%,9.500%,1.250%,1.000%,Los Angeles
Tujunga(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Universal City,7.250%,9.500%,1.250%,1.000%,Los Angeles
Val Verde Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Valencia(Santa Clarita),7.250%,9.500%,1.250%,1.000%,Los Angeles
Valinda,7.250%,9.500%,1.250%,1.000%,Los Angeles
Valley Village,7.250%,9.500%,1.250%,1.000%,Los Angeles
Valyermo,7.250%,9.500%,1.250%,1.000%,Los Angeles
Van Nuys(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Vasquez Rocks,7.250%,9.500%,1.250%,1.000%,Los Angeles
Venice(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Verdugo City(Glendale),7.250%,9.500%,1.250%,1.000%,Los Angeles
Vernon,7.250%,9.500%,1.250%,1.000%,Los Angeles
Veteran's Hospital(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
View Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Vincent,7.250%,9.500%,1.250%,1.000%,Los Angeles
Walnut Park,7.250%,9.500%,1.250%,1.000%,Los Angeles
Walnut,7.250%,9.500%,1.250%,1.000%,Los Angeles
Watts,7.250%,9.500%,1.250%,1.000%,Los Angeles
West Covina,7.250%,9.500%,1.250%,1.000%,Los Angeles
West Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
West Hollywood,7.250%,9.500%,1.250%,1.000%,Los Angeles
West Los Angeles(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Westchester(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Westlake(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Westlake Village,7.250%,9.500%,1.250%,1.000%,Los Angeles
Westwood(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Whittier,7.250%,9.500%,1.250%,1.000%,Los Angeles
Willowbrook,7.250%,9.500%,1.250%,1.000%,Los Angeles
Wilmington(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Wilsona Gardens,7.250%,9.500%,1.250%,1.000%,Los Angeles
Windsor Hills,7.250%,9.500%,1.250%,1.000%,Los Angeles
Winnetka(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Woodland Hills(Los Angeles),7.250%,9.500%,1.250%,1.000%,Los Angeles
Ahwahnee,7.250%,7.750%,0.500%,0.000%,Madera
Bass Lake,7.250%,7.750%,0.500%,0.000%,Madera
Chowchilla,7.250%,7.750%,0.500%,0.000%,Madera
Coarsegold,7.250%,7.750%,0.500%,0.000%,Madera
Madera,7.250%,8.250%,0.500%,0.500%,Madera
North Fork,7.250%,7.750%,0.500%,0.000%,Madera
O'Neals,7.250%,7.750%,0.500%,0.000%,Madera
Oakhurst,7.250%,7.750%,0.500%,0.000%,Madera
Raymond,7.250%,7.750%,0.500%,0.000%,Madera
Red Top,7.250%,7.750%,0.500%,0.000%,Madera
Wishon,7.250%,7.750%,0.500%,0.000%,Madera
Belvedere,7.250%,8.250%,1.000%,0.000%,Marin
Bolinas,7.250%,8.250%,1.000%,0.000%,Marin
Corte Madera,7.250%,9.000%,1.000%,0.750%,Marin
Dillon Beach,7.250%,8.250%,1.000%,0.000%,Marin
Dogtown,7.250%,8.250%,1.000%,0.000%,Marin
Fairfax,7.250%,9.000%,1.000%,0.750%,Marin
Fallon,7.250%,8.250%,1.000%,0.000%,Marin
Forest Knolls,7.250%,8.250%,1.000%,0.000%,Marin
Greenbrae(Larkspur),7.250%,9.000%,1.000%,0.750%,Marin
Hamilton A.F.B.(Novato),7.250%,8.500%,1.000%,0.250%,Marin
Ignacio(Novato),7.250%,8.500%,1.000%,0.250%,Marin
Inverness,7.250%,8.250%,1.000%,0.000%,Marin
Kentfield,7.250%,8.250%,1.000%,0.000%,Marin
Lagunitas,7.250%,8.250%,1.000%,0.000%,Marin
Larkspur,7.250%,9.000%,1.000%,0.750%,Marin
Marin City,7.250%,8.250%,1.000%,0.000%,Marin
Marshall,7.250%,8.250%,1.000%,0.000%,Marin
Mill Valley,7.250%,8.250%,1.000%,0.000%,Marin
Nicasio,7.250%,8.250%,1.000%,0.000%,Marin
Novato,7.250%,8.500%,1.000%,0.250%,Marin
Olema,7.250%,8.250%,1.000%,0.000%,Marin
Point Reyes Station,7.250%,8.250%,1.000%,0.000%,Marin
Ross,7.250%,8.250%,1.000%,0.000%,Marin
San Anselmo,7.250%,8.750%,1.000%,0.500%,Marin
San Geronimo,7.250%,8.250%,1.000%,0.000%,Marin
San Quentin,7.250%,8.250%,1.000%,0.000%,Marin
San Rafael,7.250%,9.000%,1.000%,0.750%,Marin
Sausalito,7.250%,8.750%,1.000%,0.500%,Marin
Stinson Beach,7.250%,8.250%,1.000%,0.000%,Marin
Tamal(San Quentin),7.250%,8.250%,1.000%,0.000%,Marin
Tiburon,7.250%,8.250%,1.000%,0.000%,Marin
Tomales,7.250%,8.250%,1.000%,0.000%,Marin
Woodacre,7.250%,8.250%,1.000%,0.000%,Marin
Bear Valley,7.250%,7.750%,0.500%,0.000%,Mariposa
Bridgeport,7.250%,7.750%,0.500%,0.000%,Mariposa
Camp Curry,7.250%,7.750%,0.500%,0.000%,Mariposa
Catheys Valley,7.250%,7.750%,0.500%,0.000%,Mariposa
Colorado,7.250%,7.750%,0.500%,0.000%,Mariposa
Coulterville,7.250%,7.750%,0.500%,0.000%,Mariposa
Curry Village,7.250%,7.750%,0.500%,0.000%,Mariposa
El Portal,7.250%,7.750%,0.500%,0.000%,Mariposa
Fish Camp,7.250%,7.750%,0.500%,0.000%,Mariposa
Hornitos,7.250%,7.750%,0.500%,0.000%,Mariposa
Mariposa,7.250%,7.750%,0.500%,0.000%,Mariposa
Midpines,7.250%,7.750%,0.500%,0.000%,Mariposa
Tuolumne Meadows,7.250%,7.750%,0.500%,0.000%,Mariposa
Wawona,7.250%,7.750%,0.500%,0.000%,Mariposa
Yosemite Lodge,7.250%,7.750%,0.500%,0.000%,Mariposa
Yosemite National Park,7.250%,7.750%,0.500%,0.000%,Mariposa
Albion,7.250%,7.875%,0.625%,0.000%,Mendocino
Boonville,7.250%,7.875%,0.625%,0.000%,Mendocino
Branscomb,7.250%,7.875%,0.625%,0.000%,Mendocino
Calpella,7.250%,7.875%,0.625%,0.000%,Mendocino
Caspar,7.250%,7.875%,0.625%,0.000%,Mendocino
Comptche,7.250%,7.875%,0.625%,0.000%,Mendocino
Covelo,7.250%,7.875%,0.625%,0.000%,Mendocino
Cummings,7.250%,7.875%,0.625%,0.000%,Mendocino
Dos Rios,7.250%,7.875%,0.625%,0.000%,Mendocino
Elk,7.250%,7.875%,0.625%,0.000%,Mendocino
Fort Bragg,7.250%,8.875%,0.625%,1.000%,Mendocino
Gualala,7.250%,7.875%,0.625%,0.000%,Mendocino
Hopland,7.250%,7.875%,0.625%,0.000%,Mendocino
Laytonville,7.250%,7.875%,0.625%,0.000%,Mendocino
Leggett,7.250%,7.875%,0.625%,0.000%,Mendocino
Littleriver,7.250%,7.875%,0.625%,0.000%,Mendocino
Mendocino,7.250%,7.875%,0.625%,0.000%,Mendocino
Navarro,7.250%,7.875%,0.625%,0.000%,Mendocino
Philo,7.250%,7.875%,0.625%,0.000%,Mendocino
Piercy,7.250%,7.875%,0.625%,0.000%,Mendocino
Point Arena,7.250%,8.375%,0.625%,0.500%,Mendocino
Potter Valley,7.250%,7.875%,0.625%,0.000%,Mendocino
Redwood Valley,7.250%,7.875%,0.625%,0.000%,Mendocino
Spyrock,7.250%,7.875%,0.625%,0.000%,Mendocino
Talmage,7.250%,7.875%,0.625%,0.000%,Mendocino
Ukiah,7.250%,8.875%,0.625%,1.000%,Mendocino
Westport,7.250%,7.875%,0.625%,0.000%,Mendocino
Willits,7.250%,8.375%,0.625%,0.500%,Mendocino
Yorkville,7.250%,7.875%,0.625%,0.000%,Mendocino
Atwater,7.250%,8.250%,0.500%,0.500%,Merced
Ballico,7.250%,7.750%,0.500%,0.000%,Merced
Castle A.F.B.,7.250%,7.750%,0.500%,0.000%,Merced
Cressey,7.250%,7.750%,0.500%,0.000%,Merced
Delhi,7.250%,7.750%,0.500%,0.000%,Merced
Dos Palos,7.250%,7.750%,0.500%,0.000%,Merced
El Nido,7.250%,7.750%,0.500%,0.000%,Merced
Gustine,7.250%,8.250%,0.500%,0.500%,Merced
Hilmar,7.250%,7.750%,0.500%,0.000%,Merced
Le Grand(Also Legrand),7.250%,7.750%,0.500%,0.000%,Merced
Livingston,7.250%,7.750%,0.500%,0.000%,Merced
Los Banos,7.250%,8.250%,0.500%,0.500%,Merced
Merced,7.250%,8.250%,0.500%,0.500%,Merced
Planada,7.250%,7.750%,0.500%,0.000%,Merced
Santa Nella,7.250%,7.750%,0.500%,0.000%,Merced
Santa Rita Park,7.250%,7.750%,0.500%,0.000%,Merced
Snelling,7.250%,7.750%,0.500%,0.000%,Merced
South Dos Palos,7.250%,7.750%,0.500%,0.000%,Merced
Stevinson,7.250%,7.750%,0.500%,0.000%,Merced
Volta,7.250%,7.750%,0.500%,0.000%,Merced
Winton,7.250%,7.750%,0.500%,0.000%,Merced
Adin,7.250%,7.250%,0.000%,0.000%,Modoc
Alturas,7.250%,7.250%,0.000%,0.000%,Modoc
Canby,7.250%,7.250%,0.000%,0.000%,Modoc
Cedarville,7.250%,7.250%,0.000%,0.000%,Modoc
Davis Creek,7.250%,7.250%,0.000%,0.000%,Modoc
Eagleville,7.250%,7.250%,0.000%,0.000%,Modoc
Fort Bidwell,7.250%,7.250%,0.000%,0.000%,Modoc
Lake City,7.250%,7.250%,0.000%,0.000%,Modoc
Likely,7.250%,7.250%,0.000%,0.000%,Modoc
Lookout,7.250%,7.250%,0.000%,0.000%,Modoc
Willow Ranch,7.250%,7.250%,0.000%,0.000%,Modoc
Benton,7.250%,7.250%,0.000%,0.000%,Mono
Bridgeport,7.250%,7.250%,0.000%,0.000%,Mono
Coleville,7.250%,7.250%,0.000%,0.000%,Mono
Crowley Lake,7.250%,7.250%,0.000%,0.000%,Mono
June Lake,7.250%,7.250%,0.000%,0.000%,Mono
Lake Mary,7.250%,7.250%,0.000%,0.000%,Mono
Lee Vining,7.250%,7.250%,0.000%,0.000%,Mono
Mammoth Lakes,7.250%,7.750%,0.000%,0.500%,Mono
Mono Lake,7.250%,7.250%,0.000%,0.000%,Mono
Sherwin Plaza,7.250%,7.250%,0.000%,0.000%,Mono
Toms Place,7.250%,7.250%,0.000%,0.000%,Mono
Topaz,7.250%,7.250%,0.000%,0.000%,Mono
Aromas,7.250%,7.750%,0.500%,0.000%,Monterey
Big Sur,7.250%,7.750%,0.500%,0.000%,Monterey
Bradley,7.250%,7.750%,0.500%,0.000%,Monterey
Camp Roberts,7.250%,7.750%,0.500%,0.000%,Monterey
Carmel Rancho,7.250%,7.750%,0.500%,0.000%,Monterey
Carmel Valley,7.250%,7.750%,0.500%,0.000%,Monterey
Carmel,7.250%,8.750%,0.500%,1.000%,Monterey
Castroville,7.250%,7.750%,0.500%,0.000%,Monterey
Chualar,7.250%,7.750%,0.500%,0.000%,Monterey
Del Monte Grove(Monterey),7.250%,8.750%,0.500%,1.000%,Monterey
Del Rey Oaks,7.250%,9.250%,0.500%,1.500%,Monterey
Fort Ord,7.250%,7.750%,0.500%,0.000%,Monterey
Fort Ord(Marina),7.250%,8.750%,0.500%,1.000%,Monterey
Fort Ord(Seaside),7.250%,9.250%,0.500%,1.500%,Monterey
Gonzales,7.250%,8.250%,0.500%,0.500%,Monterey
Greenfield,7.250%,9.500%,0.500%,1.750%,Monterey
Jolon,7.250%,7.750%,0.500%,0.000%,Monterey
King City,7.250%,8.250%,0.500%,0.500%,Monterey
Lockwood,7.250%,7.750%,0.500%,0.000%,Monterey
Lucia,7.250%,7.750%,0.500%,0.000%,Monterey
Marina,7.250%,8.750%,0.500%,1.000%,Monterey
Monterey,7.250%,8.750%,0.500%,1.000%,Monterey
Moss Landing,7.250%,7.750%,0.500%,0.000%,Monterey
Pacific Grove,7.250%,8.750%,0.500%,1.000%,Monterey
Pajaro,7.250%,7.750%,0.500%,0.000%,Monterey
Parkfield,7.250%,7.750%,0.500%,0.000%,Monterey
Pebble Beach,7.250%,7.750%,0.500%,0.000%,Monterey
Presidio of Monterey(Monterey),7.250%,8.750%,0.500%,1.000%,Monterey
Priest Valley,7.250%,7.750%,0.500%,0.000%,Monterey
Prunedale,7.250%,7.750%,0.500%,0.000%,Monterey
Royal Oaks,7.250%,7.750%,0.500%,0.000%,Monterey
Salinas,7.250%,9.250%,0.500%,1.500%,Monterey
San Ardo,7.250%,7.750%,0.500%,0.000%,Monterey
San Lucas,7.250%,7.750%,0.500%,0.000%,Monterey
Sand City,7.250%,8.750%,0.500%,1.000%,Monterey
Seaside,7.250%,9.250%,0.500%,1.500%,Monterey
Soledad,7.250%,8.750%,0.500%,1.000%,Monterey
Spreckels,7.250%,7.750%,0.500%,0.000%,Monterey
U.S. Naval Postgrad School(Monterey),7.250%,8.750%,0.500%,1.000%,Monterey
American Canyon,7.250%,7.750%,0.500%,0.000%,Napa
Angwin,7.250%,7.750%,0.500%,0.000%,Napa
Calistoga,7.250%,7.750%,0.500%,0.000%,Napa
Deer Park,7.250%,7.750%,0.500%,0.000%,Napa
Imola(Napa),7.250%,7.750%,0.500%,0.000%,Napa
Napa,7.250%,7.750%,0.500%,0.000%,Napa
Oakville,7.250%,7.750%,0.500%,0.000%,Napa
Pope Valley,7.250%,7.750%,0.500%,0.000%,Napa
Rutherford,7.250%,7.750%,0.500%,0.000%,Napa
Saint Helena,7.250%,8.250%,0.500%,0.500%,Napa
Spanish Flat,7.250%,7.750%,0.500%,0.000%,Napa
St. Helena,7.250%,8.250%,0.500%,0.500%,Napa
Steele Park,7.250%,7.750%,0.500%,0.000%,Napa
Yountville,7.250%,7.750%,0.500%,0.000%,Napa
Cedar Ridge,7.250%,7.500%,0.250%,0.000%,Nevada
Chicago Park,7.250%,7.500%,0.250%,0.000%,Nevada
Floriston,7.250%,7.500%,0.250%,0.000%,Nevada
Grass Valley,7.250%,8.500%,0.250%,1.000%,Nevada
Lake City,7.250%,7.500%,0.250%,0.000%,Nevada
Nevada City,7.250%,8.375%,0.250%,0.875%,Nevada
Norden,7.250%,7.500%,0.250%,0.000%,Nevada
North San Juan,7.250%,7.500%,0.250%,0.000%,Nevada
Penn Valley,7.250%,7.500%,0.250%,0.000%,Nevada
Rough and Ready,7.250%,7.500%,0.250%,0.000%,Nevada
Soda Springs,7.250%,7.500%,0.250%,0.000%,Nevada
Truckee,7.250%,8.250%,0.250%,0.750%,Nevada
Aliso Viejo,7.250%,7.750%,0.500%,0.000%,Orange
Anaheim,7.250%,7.750%,0.500%,0.000%,Orange
Atwood,7.250%,7.750%,0.500%,0.000%,Orange
Balboa(Newport Beach),7.250%,7.750%,0.500%,0.000%,Orange
Balboa Island(Newport Beach),7.250%,7.750%,0.500%,0.000%,Orange
Ballroad,7.250%,7.750%,0.500%,0.000%,Orange
Bolsa,7.250%,7.750%,0.500%,0.000%,Orange
Brea,7.250%,7.750%,0.500%,0.000%,Orange
Brookhurst Center,7.250%,7.750%,0.500%,0.000%,Orange
Buena Park,7.250%,7.750%,0.500%,0.000%,Orange
Capistrano Beach(Dana Point),7.250%,7.750%,0.500%,0.000%,Orange
Corona Del Mar(Newport Beach),7.250%,7.750%,0.500%,0.000%,Orange
Costa Mesa,7.250%,7.750%,0.500%,0.000%,Orange
Coto De Caza,7.250%,7.750%,0.500%,0.000%,Orange
Cowan Heights,7.250%,7.750%,0.500%,0.000%,Orange
Cypress,7.250%,7.750%,0.500%,0.000%,Orange
Dana Point,7.250%,7.750%,0.500%,0.000%,Orange
East Irvine(Irvine),7.250%,7.750%,0.500%,0.000%,Orange
El Modena,7.250%,7.750%,0.500%,0.000%,Orange
El Toro(Lake Forest),7.250%,7.750%,0.500%,0.000%,Orange
El Toro M.C.A.S.,7.250%,7.750%,0.500%,0.000%,Orange
Foothill Ranch,7.250%,7.750%,0.500%,0.000%,Orange
Fountain Valley,7.250%,8.750%,0.500%,1.000%,Orange
Fullerton,7.250%,7.750%,0.500%,0.000%,Orange
Garden Grove,7.250%,7.750%,0.500%,0.000%,Orange
Huntington,7.250%,7.750%,0.500%,0.000%,Orange
Huntington Beach,7.250%,7.750%,0.500%,0.000%,Orange
Irvine,7.250%,7.750%,0.500%,0.000%,Orange
La Habra,7.250%,8.250%,0.500%,0.500%,Orange
La Palma,7.250%,8.750%,0.500%,1.000%,Orange
Ladera Ranch,7.250%,7.750%,0.500%,0.000%,Orange
Laguna Beach,7.250%,7.750%,0.500%,0.000%,Orange
Laguna Hills,7.250%,7.750%,0.500%,0.000%,Orange
Laguna Niguel,7.250%,7.750%,0.500%,0.000%,Orange
Laguna Woods,7.250%,7.750%,0.500%,0.000%,Orange
Lake Forest,7.250%,7.750%,0.500%,0.000%,Orange
Leisure World,7.250%,7.750%,0.500%,0.000%,Orange
Leisure World(Seal Beach),7.250%,7.750%,0.500%,0.000%,Orange
Los Alamitos,7.250%,7.750%,0.500%,0.000%,Orange
Mariner,7.250%,7.750%,0.500%,0.000%,Orange
Midway City,7.250%,7.750%,0.500%,0.000%,Orange
Mission Viejo,7.250%,7.750%,0.500%,0.000%,Orange
Monarch Beach(Dana Point),7.250%,7.750%,0.500%,0.000%,Orange
Newport Beach,7.250%,7.750%,0.500%,0.000%,Orange
Orange,7.250%,7.750%,0.500%,0.000%,Orange
Placentia,7.250%,7.750%,0.500%,0.000%,Orange
Rancho Santa Margarita,7.250%,7.750%,0.500%,0.000%,Orange
Rossmoor,7.250%,7.750%,0.500%,0.000%,Orange
San Clemente,7.250%,7.750%,0.500%,0.000%,Orange
San Juan Capistrano,7.250%,7.750%,0.500%,0.000%,Orange
San Juan Plaza(San Juan Capistrano),7.250%,7.750%,0.500%,0.000%,Orange
Santa Ana,7.250%,7.750%,0.500%,0.000%,Orange
Seal Beach,7.250%,7.750%,0.500%,0.000%,Orange
Silverado Canyon,7.250%,7.750%,0.500%,0.000%,Orange
South Laguna(Laguna Beach),7.250%,7.750%,0.500%,0.000%,Orange
Stanton,7.250%,8.750%,0.500%,1.000%,Orange
Sunset Beach,7.250%,7.750%,0.500%,0.000%,Orange
Surfside(Seal Beach),7.250%,7.750%,0.500%,0.000%,Orange
Trabuco Canyon,7.250%,7.750%,0.500%,0.000%,Orange
Tustin,7.250%,7.750%,0.500%,0.000%,Orange
University Park(Irvine),7.250%,7.750%,0.500%,0.000%,Orange
Villa Park,7.250%,7.750%,0.500%,0.000%,Orange
Westminster,7.250%,8.750%,0.500%,1.000%,Orange
Yorba Linda,7.250%,7.750%,0.500%,0.000%,Orange
Alta,7.250%,7.250%,0.000%,0.000%,Placer
Applegate,7.250%,7.250%,0.000%,0.000%,Placer
Auburn,7.250%,7.250%,0.000%,0.000%,Placer
Baxter,7.250%,7.250%,0.000%,0.000%,Placer
Bowman,7.250%,7.250%,0.000%,0.000%,Placer
Carnelian Bay,7.250%,7.250%,0.000%,0.000%,Placer
Chambers Lodge,7.250%,7.250%,0.000%,0.000%,Placer
Colfax,7.250%,7.250%,0.000%,0.000%,Placer
Dutch Flat,7.250%,7.250%,0.000%,0.000%,Placer
Emigrant Gap,7.250%,7.250%,0.000%,0.000%,Placer
Foresthill,7.250%,7.250%,0.000%,0.000%,Placer
Gold Run,7.250%,7.250%,0.000%,0.000%,Placer
Granite Bay,7.250%,7.250%,0.000%,0.000%,Placer
Homewood,7.250%,7.250%,0.000%,0.000%,Placer
Iowa Hill,7.250%,7.250%,0.000%,0.000%,Placer
Kings Beach,7.250%,7.250%,0.000%,0.000%,Placer
Lincoln,7.250%,7.250%,0.000%,0.000%,Placer
Loomis,7.250%,7.500%,0.000%,0.250%,Placer
Meadow Vista,7.250%,7.250%,0.000%,0.000%,Placer
Newcastle,7.250%,7.250%,0.000%,0.000%,Placer
Olympic Valley,7.250%,7.250%,0.000%,0.000%,Placer
Penryn,7.250%,7.250%,0.000%,0.000%,Placer
Rocklin,7.250%,7.250%,0.000%,0.000%,Placer
Roseville,7.250%,7.250%,0.000%,0.000%,Placer
Sheridan,7.250%,7.250%,0.000%,0.000%,Placer
Sunset Whitney Ranch,7.250%,7.250%,0.000%,0.000%,Placer
Tahoe City,7.250%,7.250%,0.000%,0.000%,Placer
Tahoe Vista,7.250%,7.250%,0.000%,0.000%,Placer
Tahoma,7.250%,7.250%,0.000%,0.000%,Placer
Weimar,7.250%,7.250%,0.000%,0.000%,Placer
Almanor,7.250%,7.250%,0.000%,0.000%,Plumas
Beckwourth,7.250%,7.250%,0.000%,0.000%,Plumas
Belden,7.250%,7.250%,0.000%,0.000%,Plumas
Blairsden,7.250%,7.250%,0.000%,0.000%,Plumas
Canyondam,7.250%,7.250%,0.000%,0.000%,Plumas
Chester,7.250%,7.250%,0.000%,0.000%,Plumas
Chilcoot,7.250%,7.250%,0.000%,0.000%,Plumas
Clio,7.250%,7.250%,0.000%,0.000%,Plumas
Crescent Mills,7.250%,7.250%,0.000%,0.000%,Plumas
Cromberg,7.250%,7.250%,0.000%,0.000%,Plumas
Graeagle,7.250%,7.250%,0.000%,0.000%,Plumas
Greenville,7.250%,7.250%,0.000%,0.000%,Plumas
Keddie,7.250%,7.250%,0.000%,0.000%,Plumas
La Porte,7.250%,7.250%,0.000%,0.000%,Plumas
Meadow Valley,7.250%,7.250%,0.000%,0.000%,Plumas
Peninsula Village,7.250%,7.250%,0.000%,0.000%,Plumas
Portola,7.250%,7.250%,0.000%,0.000%,Plumas
Quincy,7.250%,7.250%,0.000%,0.000%,Plumas
Sloat,7.250%,7.250%,0.000%,0.000%,Plumas
Spring Garden,7.250%,7.250%,0.000%,0.000%,Plumas
Storrie,7.250%,7.250%,0.000%,0.000%,Plumas
Taylorsville,7.250%,7.250%,0.000%,0.000%,Plumas
Twain,7.250%,7.250%,0.000%,0.000%,Plumas
Vinton,7.250%,7.250%,0.000%,0.000%,Plumas
Virgilia,7.250%,7.250%,0.000%,0.000%,Plumas
Aguanga,7.250%,7.750%,0.000%,0.500%,Riverside
Alberhill(Lake Elsinore),7.250%,7.750%,0.500%,0.000%,Riverside
Anza,7.250%,7.750%,0.500%,0.000%,Riverside
Arlington(Riverside),7.250%,8.750%,0.500%,1.000%,Riverside
Banning,7.250%,7.750%,0.500%,0.000%,Riverside
Beaumont,7.250%,7.750%,0.500%,0.000%,Riverside
Bermuda Dunes,7.250%,7.750%,0.500%,0.000%,Riverside
Blythe,7.250%,7.750%,0.500%,0.000%,Riverside
Cabazon,7.250%,7.750%,0.500%,0.000%,Riverside
Calimesa,7.250%,7.750%,0.500%,0.000%,Riverside
Canyon Lake,7.250%,7.750%,0.500%,0.000%,Riverside
Cathedral City,7.250%,8.750%,0.500%,1.000%,Riverside
Cherry Valley,7.250%,7.750%,0.500%,0.000%,Riverside
Chiriaco Summit,7.250%,7.750%,0.500%,0.000%,Riverside
Coachella,7.250%,8.750%,0.500%,1.000%,Riverside
Corona,7.250%,7.750%,0.500%,0.000%,Riverside
Desert Center,7.250%,7.750%,0.500%,0.000%,Riverside
Desert Hot Springs,7.250%,7.750%,0.500%,0.000%,Riverside
Eagle Mountain,7.250%,7.750%,0.500%,0.000%,Riverside
Eastvale,7.250%,7.750%,0.500%,0.000%,Riverside
Edgemont(Moreno Valley),7.250%,7.750%,0.500%,0.000%,Riverside
Frontera,7.250%,7.750%,0.500%,0.000%,Riverside
Garnet,7.250%,7.750%,0.500%,0.000%,Riverside
Gillman Hot Springs,7.250%,7.750%,0.500%,0.000%,Riverside
Glen Avon,7.250%,7.750%,0.500%,0.000%,Riverside
Hemet,7.250%,8.750%,0.500%,1.000%,Riverside
Highgrove,7.250%,7.750%,0.500%,0.000%,Riverside
Homeland,7.250%,7.750%,0.500%,0.000%,Riverside
Homestead,7.250%,7.750%,0.500%,0.000%,Riverside
Idyllwild,7.250%,7.750%,0.500%,0.000%,Riverside
Indian Wells,7.250%,7.750%,0.500%,0.000%,Riverside
Indio,7.250%,8.750%,0.500%,1.000%,Riverside
Jurupa Valley,7.250%,7.750%,0.500%,0.000%,Riverside
La Quinta,7.250%,8.750%,0.500%,1.000%,Riverside
Lake Elsinore,7.250%,7.750%,0.500%,0.000%,Riverside
Lakeview,7.250%,7.750%,0.500%,0.000%,Riverside
Lost Lake,7.250%,7.750%,0.500%,0.000%,Riverside
March A.F.B.,7.250%,7.750%,0.500%,0.000%,Riverside
Mead Valley,7.250%,7.750%,0.500%,0.000%,Riverside
Meadowbrook,7.250%,7.750%,0.500%,0.000%,Riverside
Mecca,7.250%,7.750%,0.500%,0.000%,Riverside
Menifee,7.250%,8.750%,0.500%,1.000%,Riverside
Midland,7.250%,7.750%,0.500%,0.000%,Riverside
Mira Loma,7.250%,7.750%,0.500%,0.000%,Riverside
Moreno Valley,7.250%,7.750%,0.500%,0.000%,Riverside
Mountain Center,7.250%,7.750%,0.500%,0.000%,Riverside
Murrieta,7.250%,7.750%,0.500%,0.000%,Riverside
Norco,7.250%,7.750%,0.500%,0.000%,Riverside
North Palm Springs,7.250%,7.750%,0.500%,0.000%,Riverside
North Shore,7.250%,7.750%,0.500%,0.000%,Riverside
Nuevo,7.250%,7.750%,0.500%,0.000%,Riverside
Oasis,7.250%,7.750%,0.500%,0.000%,Riverside
Palm City,7.250%,7.750%,0.500%,0.000%,Riverside
Palm Desert,7.250%,7.750%,0.500%,0.000%,Riverside
Palm Springs,7.250%,9.250%,0.500%,1.500%,Riverside
Pedley,7.250%,7.750%,0.500%,0.000%,Riverside
Perris,7.250%,7.750%,0.500%,0.000%,Riverside
Quail Valley(Menifee),7.250%,8.750%,0.500%,1.000%,Riverside
Rancho California,7.250%,7.750%,0.500%,0.000%,Riverside
Rancho Mirage,7.250%,7.750%,0.500%,0.000%,Riverside
Ripley,7.250%,7.750%,0.500%,0.000%,Riverside
Riverside,7.250%,8.750%,0.500%,1.000%,Riverside
Romoland(Menifee),7.250%,8.750%,0.500%,1.000%,Riverside
Rubidoux,7.250%,7.750%,0.500%,0.000%,Riverside
San Jacinto,7.250%,7.750%,0.500%,0.000%,Riverside
Sky Valley,7.250%,7.750%,0.500%,0.000%,Riverside
Smoke Tree(Palm Springs),7.250%,9.250%,0.500%,1.500%,Riverside
Sun City(Menifee),7.250%,8.750%,0.500%,1.000%,Riverside
Sunnymead(Moreno Valley),7.250%,7.750%,0.500%,0.000%,Riverside
Temecula,7.250%,8.750%,0.500%,1.000%,Riverside
Thermal,7.250%,7.750%,0.500%,0.000%,Riverside
Thousand Palms,7.250%,7.750%,0.500%,0.000%,Riverside
Whitewater,7.250%,7.750%,0.500%,0.000%,Riverside
Wildomar,7.250%,7.750%,0.500%,0.000%,Riverside
Winchester,7.250%,7.750%,0.500%,0.000%,Riverside
Antelope,7.250%,7.750%,0.500%,0.000%,Sacramento
Carmichael,7.250%,7.750%,0.500%,0.000%,Sacramento
Citrus Heights,7.250%,7.750%,0.500%,0.000%,Sacramento
Courtland,7.250%,7.750%,0.500%,0.000%,Sacramento
Elk Grove,7.250%,7.750%,0.500%,0.000%,Sacramento
Elverta,7.250%,7.750%,0.500%,0.000%,Sacramento
Fair Oaks,7.250%,7.750%,0.500%,0.000%,Sacramento
Folsom,7.250%,7.750%,0.500%,0.000%,Sacramento
Freeport,7.250%,7.750%,0.500%,0.000%,Sacramento
Galt,7.250%,8.250%,0.500%,0.500%,Sacramento
Gold River,7.250%,7.750%,0.500%,0.000%,Sacramento
Herald,7.250%,7.750%,0.500%,0.000%,Sacramento
Hood,7.250%,7.750%,0.500%,0.000%,Sacramento
Isleton,7.250%,8.750%,0.500%,1.000%,Sacramento
Locke,7.250%,7.750%,0.500%,0.000%,Sacramento
Mather,7.250%,7.750%,0.500%,0.000%,Sacramento
McClellan,7.250%,7.750%,0.500%,0.000%,Sacramento
North Highlands,7.250%,7.750%,0.500%,0.000%,Sacramento
Orangevale,7.250%,7.750%,0.500%,0.000%,Sacramento
Rancho Cordova,7.250%,8.250%,0.500%,0.500%,Sacramento
Rancho Murieta,7.250%,7.750%,0.500%,0.000%,Sacramento
Represa(Folsom Prison),7.250%,7.750%,0.500%,0.000%,Sacramento
Rio Linda,7.250%,7.750%,0.500%,0.000%,Sacramento
Ryde,7.250%,7.750%,0.500%,0.000%,Sacramento
Sacramento,7.250%,8.250%,0.500%,0.500%,Sacramento
Sherman Island,7.250%,7.750%,0.500%,0.000%,Sacramento
Sloughhouse,7.250%,7.750%,0.500%,0.000%,Sacramento
Walnut Grove,7.250%,7.750%,0.500%,0.000%,Sacramento
Wilton,7.250%,7.750%,0.500%,0.000%,Sacramento
Hollister,7.250%,8.250%,0.000%,1.000%,San Benito
Idria,7.250%,7.250%,0.000%,0.000%,San Benito
New Idria,7.250%,7.250%,0.000%,0.000%,San Benito
Paicines,7.250%,7.250%,0.000%,0.000%,San Benito
San Benito,7.250%,7.250%,0.000%,0.000%,San Benito
San Juan Bautista,7.250%,8.000%,0.000%,0.750%,San Benito
Tres Pinos,7.250%,7.250%,0.000%,0.000%,San Benito
Adelanto,7.250%,7.750%,0.500%,0.000%,San Bernardino
Alta Loma(Rancho Cucamonga),7.250%,7.750%,0.500%,0.000%,San Bernardino
Amboy,7.250%,7.750%,0.500%,0.000%,San Bernardino
Angelus Oaks,7.250%,7.750%,0.500%,0.000%,San Bernardino
Apple Valley,7.250%,7.750%,0.500%,0.000%,San Bernardino
Argus,7.250%,7.750%,0.500%,0.000%,San Bernardino
Arrowbear Lake,7.250%,7.750%,0.500%,0.000%,San Bernardino
Arrowhead Highlands,7.250%,7.750%,0.500%,0.000%,San Bernardino
Baker,7.250%,7.750%,0.500%,0.000%,San Bernardino
Barstow,7.250%,7.750%,0.500%,0.000%,San Bernardino
Base Line,7.250%,7.750%,0.500%,0.000%,San Bernardino
Big Bear City,7.250%,7.750%,0.500%,0.000%,San Bernardino
Big Bear Lake,7.250%,7.750%,0.500%,0.000%,San Bernardino
Big River,7.250%,7.750%,0.500%,0.000%,San Bernardino
Bloomington,7.250%,7.750%,0.500%,0.000%,San Bernardino
Blue Jay,7.250%,7.750%,0.500%,0.000%,San Bernardino
Bryn Mawr,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cadiz,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cedar Glen,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cedarpines Park,7.250%,7.750%,0.500%,0.000%,San Bernardino
Chino Hills,7.250%,7.750%,0.500%,0.000%,San Bernardino
Chino,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cima,7.250%,7.750%,0.500%,0.000%,San Bernardino
Colton,7.250%,7.750%,0.500%,0.000%,San Bernardino
Crest Park,7.250%,7.750%,0.500%,0.000%,San Bernardino
Crestline,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cross Roads,7.250%,7.750%,0.500%,0.000%,San Bernardino
Cucamonga(Rancho Cucamonga),7.250%,7.750%,0.500%,0.000%,San Bernardino
Daggett,7.250%,7.750%,0.500%,0.000%,San Bernardino
Del Rosa,7.250%,7.750%,0.500%,0.000%,San Bernardino
Earp,7.250%,7.750%,0.500%,0.000%,San Bernardino
East Highlands(Highland),7.250%,7.750%,0.500%,0.000%,San Bernardino
Eastside,7.250%,7.750%,0.500%,0.000%,San Bernardino
Essex,7.250%,7.750%,0.500%,0.000%,San Bernardino
Etiwanda(Rancho Cucamonga),7.250%,7.750%,0.500%,0.000%,San Bernardino
Fawnskin,7.250%,7.750%,0.500%,0.000%,San Bernardino
Fenner,7.250%,7.750%,0.500%,0.000%,San Bernardino
Fontana,7.250%,7.750%,0.500%,0.000%,San Bernardino
Forest Falls,7.250%,7.750%,0.500%,0.000%,San Bernardino
Fort Irwin,7.250%,7.750%,0.500%,0.000%,San Bernardino
George A.F.B.,7.250%,7.750%,0.500%,0.000%,San Bernardino
Grand Terrace,7.250%,7.750%,0.500%,0.000%,San Bernardino
Green Valley Lake,7.250%,7.750%,0.500%,0.000%,San Bernardino
Guasti(Ontario),7.250%,7.750%,0.500%,0.000%,San Bernardino
Havasu Lake,7.250%,7.750%,0.500%,0.000%,San Bernardino
Helendale,7.250%,7.750%,0.500%,0.000%,San Bernardino
Hesperia,7.250%,7.750%,0.500%,0.000%,San Bernardino
Highland,7.250%,7.750%,0.500%,0.000%,San Bernardino
Hinkley,7.250%,7.750%,0.500%,0.000%,San Bernardino
Ivanpah,7.250%,7.750%,0.500%,0.000%,San Bernardino
Joshua Tree,7.250%,7.750%,0.500%,0.000%,San Bernardino
Kelso,7.250%,7.750%,0.500%,0.000%,San Bernardino
Lake Arrowhead,7.250%,7.750%,0.500%,0.000%,San Bernardino
Landers,7.250%,7.750%,0.500%,0.000%,San Bernardino
Lenwood,7.250%,7.750%,0.500%,0.000%,San Bernardino
Loma Linda,7.250%,7.750%,0.500%,0.000%,San Bernardino
Los Serranos(Chino Hills),7.250%,7.750%,0.500%,0.000%,San Bernardino
Lucerne Valley,7.250%,7.750%,0.500%,0.000%,San Bernardino
Ludlow,7.250%,7.750%,0.500%,0.000%,San Bernardino
Lytle Creek,7.250%,7.750%,0.500%,0.000%,San Bernardino
Marine Corps(Twentynine Palms),7.250%,7.750%,0.500%,0.000%,San Bernardino
Mentone,7.250%,7.750%,0.500%,0.000%,San Bernardino
Montclair,7.250%,8.000%,0.500%,0.250%,San Bernardino
Moonridge,7.250%,7.750%,0.500%,0.000%,San Bernardino
Morongo Valley,7.250%,7.750%,0.500%,0.000%,San Bernardino
Mountain Pass,7.250%,7.750%,0.500%,0.000%,San Bernardino
Mt. Baldy,7.250%,7.750%,0.500%,0.000%,San Bernardino
Muscoy,7.250%,7.750%,0.500%,0.000%,San Bernardino
Needles,7.250%,7.750%,0.500%,0.000%,San Bernardino
Newberry,7.250%,7.750%,0.500%,0.000%,San Bernardino
Newberry Springs,7.250%,7.750%,0.500%,0.000%,San Bernardino
Nipton,7.250%,7.750%,0.500%,0.000%,San Bernardino
Norton A.F.B.(San Bernardino),7.250%,8.000%,0.500%,0.250%,San Bernardino
Ontario,7.250%,7.750%,0.500%,0.000%,San Bernardino
Oro Grande,7.250%,7.750%,0.500%,0.000%,San Bernardino
Parker Dam,7.250%,7.750%,0.500%,0.000%,San Bernardino
Patton,7.250%,7.750%,0.500%,0.000%,San Bernardino
Phelan,7.250%,7.750%,0.500%,0.000%,San Bernardino
Pinon Hills,7.250%,7.750%,0.500%,0.000%,San Bernardino
Pioneertown,7.250%,7.750%,0.500%,0.000%,San Bernardino
Rancho Cucamonga,7.250%,7.750%,0.500%,0.000%,San Bernardino
Red Mountain,7.250%,7.750%,0.500%,0.000%,San Bernardino
Redlands,7.250%,7.750%,0.500%,0.000%,San Bernardino
Rialto,7.250%,7.750%,0.500%,0.000%,San Bernardino
Rimforest,7.250%,7.750%,0.500%,0.000%,San Bernardino
Running Springs,7.250%,7.750%,0.500%,0.000%,San Bernardino
San Bernardino,7.250%,8.000%,0.500%,0.250%,San Bernardino
Skyforest,7.250%,7.750%,0.500%,0.000%,San Bernardino
Smoke Tree(Twentynine Palms),7.250%,7.750%,0.500%,0.000%,San Bernardino
Sugarloaf,7.250%,7.750%,0.500%,0.000%,San Bernardino
Summit,7.250%,7.750%,0.500%,0.000%,San Bernardino
Trona,7.250%,7.750%,0.500%,0.000%,San Bernardino
Twentynine Palms,7.250%,7.750%,0.500%,0.000%,San Bernardino
Twin Peaks,7.250%,7.750%,0.500%,0.000%,San Bernardino
Upland,7.250%,7.750%,0.500%,0.000%,San Bernardino
Victorville,7.250%,7.750%,0.500%,0.000%,San Bernardino
Vidal,7.250%,7.750%,0.500%,0.000%,San Bernardino
Westend,7.250%,7.750%,0.500%,0.000%,San Bernardino
Wrightwood,7.250%,7.750%,0.500%,0.000%,San Bernardino
Yermo,7.250%,7.750%,0.500%,0.000%,San Bernardino
Yucaipa,7.250%,7.750%,0.500%,0.000%,San Bernardino
Yucca Valley,7.250%,8.750%,0.500%,1.000%,San Bernardino
Agua Caliente Springs,7.250%,7.750%,0.500%,0.000%,San Diego
Alpine,7.250%,7.750%,0.500%,0.000%,San Diego
Balboa Park(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Bonita,7.250%,7.750%,0.500%,0.000%,San Diego
Bonsall,7.250%,7.750%,0.500%,0.000%,San Diego
Borrego Springs,7.250%,7.750%,0.500%,0.000%,San Diego
Bostonia,7.250%,7.750%,0.500%,0.000%,San Diego
Boulevard,7.250%,7.750%,0.500%,0.000%,San Diego
Camp Pendleton,7.250%,7.750%,0.500%,0.000%,San Diego
Campo,7.250%,7.750%,0.500%,0.000%,San Diego
Cardiff By The Sea(Encinitas),7.250%,7.750%,0.500%,0.000%,San Diego
Carlsbad,7.250%,7.750%,0.500%,0.000%,San Diego
Chula Vista,7.250%,8.750%,0.500%,1.000%,San Diego
College Grove Center,7.250%,7.750%,0.500%,0.000%,San Diego
Coronado,7.250%,7.750%,0.500%,0.000%,San Diego
Crest,7.250%,7.750%,0.500%,0.000%,San Diego
Del Mar,7.250%,8.750%,0.500%,1.000%,San Diego
Descanso,7.250%,7.750%,0.500%,0.000%,San Diego
Dulzura,7.250%,7.750%,0.500%,0.000%,San Diego
El Cajon,7.250%,8.250%,0.500%,0.500%,San Diego
Encinitas,7.250%,7.750%,0.500%,0.000%,San Diego
Escondido,7.250%,7.750%,0.500%,0.000%,San Diego
Fallbrook,7.250%,7.750%,0.500%,0.000%,San Diego
Fallbrook Junction,7.250%,7.750%,0.500%,0.000%,San Diego
Flinn Springs,7.250%,7.750%,0.500%,0.000%,San Diego
Guatay,7.250%,7.750%,0.500%,0.000%,San Diego
Harbison Canyon,7.250%,7.750%,0.500%,0.000%,San Diego
Hillcrest(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Imperial Beach,7.250%,7.750%,0.500%,0.000%,San Diego
Jacumba,7.250%,7.750%,0.500%,0.000%,San Diego
Jamacha,7.250%,7.750%,0.500%,0.000%,San Diego
Jamul,7.250%,7.750%,0.500%,0.000%,San Diego
Johnstown,7.250%,7.750%,0.500%,0.000%,San Diego
Julian,7.250%,7.750%,0.500%,0.000%,San Diego
La Jolla(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
La Mesa,7.250%,8.500%,0.500%,0.750%,San Diego
Lake San Marcos,7.250%,7.750%,0.500%,0.000%,San Diego
Lakeside,7.250%,7.750%,0.500%,0.000%,San Diego
Lemon Grove,7.250%,7.750%,0.500%,0.000%,San Diego
Leucadia(Encinitas),7.250%,7.750%,0.500%,0.000%,San Diego
Lincoln Acres,7.250%,7.750%,0.500%,0.000%,San Diego
Miramar(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Mount Laguna,7.250%,7.750%,0.500%,0.000%,San Diego
National City,7.250%,8.750%,0.500%,1.000%,San Diego
Naval(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Naval Air Station(Coronado),7.250%,7.750%,0.500%,0.000%,San Diego
Naval Hospital(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Naval Training Center(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Oceanside,7.250%,7.750%,0.500%,0.000%,San Diego
Ocotillo Wells,7.250%,7.750%,0.500%,0.000%,San Diego
Olivenhain(Encinitas),7.250%,7.750%,0.500%,0.000%,San Diego
Otay(Chula Vista),7.250%,8.750%,0.500%,1.000%,San Diego
Pala,7.250%,7.750%,0.500%,0.000%,San Diego
Palm City(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Palomar Mountain,7.250%,7.750%,0.500%,0.000%,San Diego
Pauma Valley,7.250%,7.750%,0.500%,0.000%,San Diego
Pine Valley,7.250%,7.750%,0.500%,0.000%,San Diego
Potrero,7.250%,7.750%,0.500%,0.000%,San Diego
Poway,7.250%,7.750%,0.500%,0.000%,San Diego
Rainbow,7.250%,7.750%,0.500%,0.000%,San Diego
Ramona,7.250%,7.750%,0.500%,0.000%,San Diego
Ranchita,7.250%,7.750%,0.500%,0.000%,San Diego
Rancho Bernardo(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Rancho Santa Fe,7.250%,7.750%,0.500%,0.000%,San Diego
San Carlos(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
San Diego,7.250%,7.750%,0.500%,0.000%,San Diego
San Luis Rey(Oceanside),7.250%,7.750%,0.500%,0.000%,San Diego
San Marcos,7.250%,7.750%,0.500%,0.000%,San Diego
San Ysidro(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Santa Ysabel,7.250%,7.750%,0.500%,0.000%,San Diego
Santee,7.250%,7.750%,0.500%,0.000%,San Diego
Solana Beach,7.250%,7.750%,0.500%,0.000%,San Diego
Spring Valley,7.250%,7.750%,0.500%,0.000%,San Diego
Sunnyside,7.250%,7.750%,0.500%,0.000%,San Diego
Tecate,7.250%,7.750%,0.500%,0.000%,San Diego
Tierra Del Sol,7.250%,7.750%,0.500%,0.000%,San Diego
Tierrasanta(San Diego),7.250%,7.750%,0.500%,0.000%,San Diego
Valley Center,7.250%,7.750%,0.500%,0.000%,San Diego
Vista,7.250%,8.250%,0.500%,0.500%,San Diego
Warner Springs,7.250%,7.750%,0.500%,0.000%,San Diego
Presidio(San Francisco),7.250%,8.500%,1.250%,0.000%,San Francisco
San Francisco,7.250%,8.500%,1.250%,0.000%,San Francisco
Acampo,7.250%,7.750%,0.500%,0.000%,San Joaquin
Banta,7.250%,7.750%,0.500%,0.000%,San Joaquin
Clements,7.250%,7.750%,0.500%,0.000%,San Joaquin
Escalon,7.250%,7.750%,0.500%,0.000%,San Joaquin
Farmington,7.250%,7.750%,0.500%,0.000%,San Joaquin
French Camp,7.250%,7.750%,0.500%,0.000%,San Joaquin
Holt,7.250%,7.750%,0.500%,0.000%,San Joaquin
Lathrop,7.250%,8.750%,0.500%,1.000%,San Joaquin
Lincoln Village,7.250%,7.750%,0.500%,0.000%,San Joaquin
Linden,7.250%,7.750%,0.500%,0.000%,San Joaquin
Lockeford,7.250%,7.750%,0.500%,0.000%,San Joaquin
Lodi,7.250%,7.750%,0.500%,0.000%,San Joaquin
Manteca,7.250%,8.250%,0.500%,0.500%,San Joaquin
Ripon,7.250%,7.750%,0.500%,0.000%,San Joaquin
Sharpe Army Depot,7.250%,7.750%,0.500%,0.000%,San Joaquin
Stockton,7.250%,9.000%,0.500%,1.250%,San Joaquin
Thornton,7.250%,7.750%,0.500%,0.000%,San Joaquin
Tracy,7.250%,8.250%,0.500%,0.500%,San Joaquin
Vernalis,7.250%,7.750%,0.500%,0.000%,San Joaquin
Victor,7.250%,7.750%,0.500%,0.000%,San Joaquin
Woodbridge,7.250%,7.750%,0.500%,0.000%,San Joaquin
Adelaida,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Arroyo Grande,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Atascadero,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Avila Beach,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Baywood Park,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
California Valley,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Cambria,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Cayucos,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Cholame,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Creston,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Del Mar Heights(Morro Bay),7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Grover Beach,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Halcyon,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Harmony,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Los Osos,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Los Padres,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Morro Bay,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Morro Plaza,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Nipomo,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Oceano,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Paso Robles,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Pismo Beach,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
San Luis Obispo,7.250%,7.750%,0.000%,0.500%,San Luis Obispo
San Miguel,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
San Simeon,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Santa Margarita,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Shandon,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Shell Beach(Pismo Beach),7.250%,7.750%,0.000%,0.500%,San Luis Obispo
Templeton,7.250%,7.250%,0.000%,0.000%,San Luis Obispo
Atherton,7.250%,8.750%,1.500%,0.000%,San Mateo
Belmont,7.250%,9.250%,1.500%,0.500%,San Mateo
Brisbane,7.250%,8.750%,1.500%,0.000%,San Mateo
Burlingame,7.250%,9.000%,1.500%,0.250%,San Mateo
Colma,7.250%,8.750%,1.500%,0.000%,San Mateo
Daly City,7.250%,8.750%,1.500%,0.000%,San Mateo
East Palo Alto,7.250%,9.250%,1.500%,0.500%,San Mateo
El Granada,7.250%,8.750%,1.500%,0.000%,San Mateo
Emerald Hills(Redwood City),7.250%,8.750%,1.500%,0.000%,San Mateo
Foster City,7.250%,8.750%,1.500%,0.000%,San Mateo
Half Moon Bay,7.250%,8.750%,1.500%,0.000%,San Mateo
Hillsborough,7.250%,8.750%,1.500%,0.000%,San Mateo
Hillsdale(San Mateo),7.250%,9.000%,1.500%,0.250%,San Mateo
La Honda,7.250%,8.750%,1.500%,0.000%,San Mateo
Ladera,7.250%,8.750%,1.500%,0.000%,San Mateo
Loma Mar,7.250%,8.750%,1.500%,0.000%,San Mateo
Marsh Manor,7.250%,8.750%,1.500%,0.000%,San Mateo
Menlo Park,7.250%,8.750%,1.500%,0.000%,San Mateo
Millbrae,7.250%,8.750%,1.500%,0.000%,San Mateo
Montara,7.250%,8.750%,1.500%,0.000%,San Mateo
Moss Beach,7.250%,8.750%,1.500%,0.000%,San Mateo
Pacifica,7.250%,8.750%,1.500%,0.000%,San Mateo
Pescadero,7.250%,8.750%,1.500%,0.000%,San Mateo
Portola Valley,7.250%,8.750%,1.500%,0.000%,San Mateo
Redwood City,7.250%,8.750%,1.500%,0.000%,San Mateo
San Bruno,7.250%,8.750%,1.500%,0.000%,San Mateo
San Carlos,7.250%,8.750%,1.500%,0.000%,San Mateo
San Gregorio,7.250%,8.750%,1.500%,0.000%,San Mateo
San Mateo,7.250%,9.000%,1.500%,0.250%,San Mateo
South San Francisco,7.250%,9.250%,1.500%,0.500%,San Mateo
Woodside,7.250%,8.750%,1.500%,0.000%,San Mateo
Ballard,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Betteravia,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Buellton,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Carpinteria,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Casmalia,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Cuyama,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Garey,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Gaviota,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Goleta,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Guadalupe,7.250%,8.000%,0.500%,0.250%,Santa Barbara
Isla Vista,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Lompoc,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Los Alamos,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Los Olivos,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Montecito,7.250%,7.750%,0.500%,0.000%,Santa Barbara
New Cuyama,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Orcutt,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Refugio Beach,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Santa Barbara,7.250%,8.750%,0.500%,1.000%,Santa Barbara
Santa Maria,7.250%,8.000%,0.500%,0.250%,Santa Barbara
Santa Ynez,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Sisquoc,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Solvang,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Summerland,7.250%,7.750%,0.500%,0.000%,Santa Barbara
University,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Vandenberg A.F.B,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Ventucopa,7.250%,7.750%,0.500%,0.000%,Santa Barbara
Almaden Valley,7.250%,9.000%,1.750%,0.000%,Santa Clara
Alviso(San Jose),7.250%,9.250%,1.750%,0.250%,Santa Clara
Blossom Hill,7.250%,9.000%,1.750%,0.000%,Santa Clara
Blossom Valley,7.250%,9.000%,1.750%,0.000%,Santa Clara
Cambrian Park,7.250%,9.000%,1.750%,0.000%,Santa Clara
Campbell,7.250%,9.250%,1.750%,0.250%,Santa Clara
Coyote,7.250%,9.000%,1.750%,0.000%,Santa Clara
Cupertino,7.250%,9.000%,1.750%,0.000%,Santa Clara
Gilroy,7.250%,9.000%,1.750%,0.000%,Santa Clara
Holy City,7.250%,9.000%,1.750%,0.000%,Santa Clara
Lorre Estates,7.250%,9.000%,1.750%,0.000%,Santa Clara
Los Altos Hills,7.250%,9.000%,1.750%,0.000%,Santa Clara
Los Altos,7.250%,9.000%,1.750%,0.000%,Santa Clara
Los Gatos,7.250%,9.000%,1.750%,0.000%,Santa Clara
Milpitas,7.250%,9.000%,1.750%,0.000%,Santa Clara
Moffett Field,7.250%,9.000%,1.750%,0.000%,Santa Clara
Monta Vista,7.250%,9.000%,1.750%,0.000%,Santa Clara
Monte Sereno,7.250%,9.000%,1.750%,0.000%,Santa Clara
Morgan Hill,7.250%,9.000%,1.750%,0.000%,Santa Clara
Mount Hamilton,7.250%,9.000%,1.750%,0.000%,Santa Clara
Mountain View,7.250%,9.000%,1.750%,0.000%,Santa Clara
New Almaden,7.250%,9.000%,1.750%,0.000%,Santa Clara
Palo Alto,7.250%,9.000%,1.750%,0.000%,Santa Clara
Permanente,7.250%,9.000%,1.750%,0.000%,Santa Clara
Redwood Estates,7.250%,9.000%,1.750%,0.000%,Santa Clara
San Jose,7.250%,9.250%,1.750%,0.250%,Santa Clara
San Martin,7.250%,9.000%,1.750%,0.000%,Santa Clara
San Tomas,7.250%,9.000%,1.750%,0.000%,Santa Clara
Santa Clara,7.250%,9.000%,1.750%,0.000%,Santa Clara
Saratoga,7.250%,9.000%,1.750%,0.000%,Santa Clara
Stanford,7.250%,9.000%,1.750%,0.000%,Santa Clara
Sunnyvale,7.250%,9.000%,1.750%,0.000%,Santa Clara
Valley Fair,7.250%,9.000%,1.750%,0.000%,Santa Clara
Aptos,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Ben Lomond,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Big Basin,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Bonny Doon,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Boulder Creek,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Brookdale,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Capitola,7.250%,9.000%,1.250%,0.500%,Santa Cruz
Corralitos,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Davenport,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Felton,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Freedom,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Freedom(Watsonville),7.250%,9.250%,1.250%,0.750%,Santa Cruz
La Selva Beach,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Live Oak,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Lockheed,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Monterey Bay Academy,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Mount Hermon,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Opal Cliffs,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Rio Del Mar,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Santa Cruz,7.250%,9.250%,1.250%,0.750%,Santa Cruz
Scotts Valley,7.250%,9.000%,1.250%,0.500%,Santa Cruz
Seabright(Santa Cruz),7.250%,9.000%,1.250%,0.500%,Santa Cruz
Soquel,7.250%,8.500%,1.250%,0.000%,Santa Cruz
Watsonville,7.250%,9.250%,1.250%,0.750%,Santa Cruz
Anderson,7.250%,7.750%,0.000%,0.500%,Shasta
Bella Vista,7.250%,7.250%,0.000%,0.000%,Shasta
Big Bend,7.250%,7.250%,0.000%,0.000%,Shasta
Burney,7.250%,7.250%,0.000%,0.000%,Shasta
Cassel,7.250%,7.250%,0.000%,0.000%,Shasta
Castella,7.250%,7.250%,0.000%,0.000%,Shasta
Central Valley,7.250%,7.250%,0.000%,0.000%,Shasta
Cottonwood,7.250%,7.250%,0.000%,0.000%,Shasta
Enterprise,7.250%,7.250%,0.000%,0.000%,Shasta
Fall River Mills,7.250%,7.250%,0.000%,0.000%,Shasta
French Gulch,7.250%,7.250%,0.000%,0.000%,Shasta
Glenburn,7.250%,7.250%,0.000%,0.000%,Shasta
Hat Creek,7.250%,7.250%,0.000%,0.000%,Shasta
Igo,7.250%,7.250%,0.000%,0.000%,Shasta
Keswick,7.250%,7.250%,0.000%,0.000%,Shasta
Lakehead,7.250%,7.250%,0.000%,0.000%,Shasta
Manzanita Lake,7.250%,7.250%,0.000%,0.000%,Shasta
McArthur,7.250%,7.250%,0.000%,0.000%,Shasta
Millville,7.250%,7.250%,0.000%,0.000%,Shasta
Montgomery Creek,7.250%,7.250%,0.000%,0.000%,Shasta
O'Brien,7.250%,7.250%,0.000%,0.000%,Shasta
Oak Run,7.250%,7.250%,0.000%,0.000%,Shasta
Old Station,7.250%,7.250%,0.000%,0.000%,Shasta
Olinda,7.250%,7.250%,0.000%,0.000%,Shasta
Ono,7.250%,7.250%,0.000%,0.000%,Shasta
Palo Cedro,7.250%,7.250%,0.000%,0.000%,Shasta
Platina,7.250%,7.250%,0.000%,0.000%,Shasta
Project City,7.250%,7.250%,0.000%,0.000%,Shasta
Redding,7.250%,7.250%,0.000%,0.000%,Shasta
Round Mountain,7.250%,7.250%,0.000%,0.000%,Shasta
Shasta,7.250%,7.250%,0.000%,0.000%,Shasta
Shasta Lake,7.250%,7.250%,0.000%,0.000%,Shasta
Shingletown,7.250%,7.250%,0.000%,0.000%,Shasta
Summit City,7.250%,7.250%,0.000%,0.000%,Shasta
Whiskeytown,7.250%,7.250%,0.000%,0.000%,Shasta
Whitmore,7.250%,7.250%,0.000%,0.000%,Shasta
Wildwood,7.250%,7.250%,0.000%,0.000%,Shasta
Alleghany,7.250%,7.250%,0.000%,0.000%,Sierra
Calpine,7.250%,7.250%,0.000%,0.000%,Sierra
Downieville,7.250%,7.250%,0.000%,0.000%,Sierra
Goodyears Bar,7.250%,7.250%,0.000%,0.000%,Sierra
Loyalton,7.250%,7.250%,0.000%,0.000%,Sierra
Sattley,7.250%,7.250%,0.000%,0.000%,Sierra
Sierra City,7.250%,7.250%,0.000%,0.000%,Sierra
Sierraville,7.250%,7.250%,0.000%,0.000%,Sierra
Callahan,7.250%,7.250%,0.000%,0.000%,Siskiyou
Cecilville,7.250%,7.250%,0.000%,0.000%,Siskiyou
Clear Creek,7.250%,7.250%,0.000%,0.000%,Siskiyou
Dorris,7.250%,7.250%,0.000%,0.000%,Siskiyou
Dunsmuir,7.250%,7.750%,0.000%,0.500%,Siskiyou
Edgewood,7.250%,7.250%,0.000%,0.000%,Siskiyou
Etna,7.250%,7.250%,0.000%,0.000%,Siskiyou
Forks of Salmon,7.250%,7.250%,0.000%,0.000%,Siskiyou
Fort Jones,7.250%,7.250%,0.000%,0.000%,Siskiyou
Gazelle,7.250%,7.250%,0.000%,0.000%,Siskiyou
Greenview,7.250%,7.250%,0.000%,0.000%,Siskiyou
Grenada,7.250%,7.250%,0.000%,0.000%,Siskiyou
Happy Camp,7.250%,7.250%,0.000%,0.000%,Siskiyou
Hilt,7.250%,7.250%,0.000%,0.000%,Siskiyou
Hornbrook,7.250%,7.250%,0.000%,0.000%,Siskiyou
Horse Creek,7.250%,7.250%,0.000%,0.000%,Siskiyou
Kinyon,7.250%,7.250%,0.000%,0.000%,Siskiyou
Klamath River,7.250%,7.250%,0.000%,0.000%,Siskiyou
Lake Shastina,7.250%,7.250%,0.000%,0.000%,Siskiyou
Macdoel,7.250%,7.250%,0.000%,0.000%,Siskiyou
McCloud,7.250%,7.250%,0.000%,0.000%,Siskiyou
Montague,7.250%,7.250%,0.000%,0.000%,Siskiyou
Mount Hebron,7.250%,7.250%,0.000%,0.000%,Siskiyou
Mount Shasta,7.250%,7.500%,0.000%,0.250%,Siskiyou
Pondosa,7.250%,7.250%,0.000%,0.000%,Siskiyou
Sawyers Bar,7.250%,7.250%,0.000%,0.000%,Siskiyou
Scott Bar,7.250%,7.250%,0.000%,0.000%,Siskiyou
Seiad Valley,7.250%,7.250%,0.000%,0.000%,Siskiyou
Somes Bar,7.250%,7.250%,0.000%,0.000%,Siskiyou
Tulelake,7.250%,7.250%,0.000%,0.000%,Siskiyou
Weed,7.250%,7.500%,0.000%,0.250%,Siskiyou
Yreka,7.250%,7.750%,0.000%,0.500%,Siskiyou
Benicia,7.250%,8.375%,1.125%,0.000%,Solano
Birds Landing,7.250%,7.375%,1.125%,0.000%,Solano
Dairy Farm,7.250%,7.375%,1.125%,0.000%,Solano
Dixon,7.250%,7.375%,1.125%,0.000%,Solano
Elmira,7.250%,7.375%,1.125%,0.000%,Solano
Fairfield,7.250%,8.375%,1.125%,0.000%,Solano
Larwin Plaza,7.250%,7.375%,1.125%,0.000%,Solano
Liberty Farms,7.250%,7.375%,1.125%,0.000%,Solano
Mare Island(Vallejo),7.250%,8.375%,1.125%,0.000%,Solano
Rio Vista,7.250%,8.125%,1.125%,0.000%,Solano
Suisun City,7.250%,8.375%,1.125%,0.000%,Solano
Travis A.F.B.(Fairfield),7.250%,8.375%,1.125%,0.000%,Solano
Vacaville,7.250%,8.125%,1.125%,0.000%,Solano
Vallejo,7.250%,8.375%,1.125%,0.000%,Solano
Agua Caliente,7.250%,8.125%,0.875%,0.000%,Sonoma
Annapolis,7.250%,8.125%,0.875%,0.000%,Sonoma
Asti,7.250%,8.125%,0.875%,0.000%,Sonoma
Bodega,7.250%,8.125%,0.875%,0.000%,Sonoma
Bodega Bay,7.250%,8.125%,0.875%,0.000%,Sonoma
Boyes Hot Springs,7.250%,8.125%,0.875%,0.000%,Sonoma
Camp Meeker,7.250%,8.125%,0.875%,0.000%,Sonoma
Cazadero,7.250%,8.125%,0.875%,0.000%,Sonoma
Cloverdale,7.250%,8.125%,0.875%,0.000%,Sonoma
Cotati,7.250%,9.125%,0.875%,1.000%,Sonoma
Duncans Mills,7.250%,8.125%,0.875%,0.000%,Sonoma
El Verano,7.250%,8.125%,0.875%,0.000%,Sonoma
Eldridge,7.250%,8.125%,0.875%,0.000%,Sonoma
Forestville,7.250%,8.125%,0.875%,0.000%,Sonoma
Freestone,7.250%,8.125%,0.875%,0.000%,Sonoma
Fulton,7.250%,8.125%,0.875%,0.000%,Sonoma
Geyserville,7.250%,8.125%,0.875%,0.000%,Sonoma
Glen Ellen,7.250%,8.125%,0.875%,0.000%,Sonoma
Graton,7.250%,8.125%,0.875%,0.000%,Sonoma
Guerneville,7.250%,8.125%,0.875%,0.000%,Sonoma
Healdsburg,7.250%,8.625%,0.875%,0.500%,Sonoma
Jenner,7.250%,8.125%,0.875%,0.000%,Sonoma
Kenwood,7.250%,8.125%,0.875%,0.000%,Sonoma
Korbel,7.250%,8.125%,0.875%,0.000%,Sonoma
Larkfield,7.250%,8.125%,0.875%,0.000%,Sonoma
Monte Rio,7.250%,8.125%,0.875%,0.000%,Sonoma
Occidental,7.250%,8.125%,0.875%,0.000%,Sonoma
Penngrove,7.250%,8.125%,0.875%,0.000%,Sonoma
Petaluma,7.250%,8.125%,0.875%,0.000%,Sonoma
Rio Nido,7.250%,8.125%,0.875%,0.000%,Sonoma
Rohnert Park,7.250%,8.625%,0.875%,0.500%,Sonoma
Roseland,7.250%,8.125%,0.875%,0.000%,Sonoma
Santa Rosa,7.250%,8.625%,0.875%,0.500%,Sonoma
Sea Ranch,7.250%,8.125%,0.875%,0.000%,Sonoma
Sebastopol,7.250%,8.875%,0.875%,0.750%,Sonoma
Sonoma,7.250%,8.625%,0.875%,0.500%,Sonoma
Stewarts Point,7.250%,8.125%,0.875%,0.000%,Sonoma
Two Rock Coast Guard Station,7.250%,8.125%,0.875%,0.000%,Sonoma
Valley Ford,7.250%,8.125%,0.875%,0.000%,Sonoma
Villa Grande,7.250%,8.125%,0.875%,0.000%,Sonoma
Vineburg,7.250%,8.125%,0.875%,0.000%,Sonoma
Windsor,7.250%,8.125%,0.875%,0.000%,Sonoma
Ceres,7.250%,8.375%,1.125%,0.000%,Stanislaus
Crows Landing,7.250%,7.875%,1.125%,0.000%,Stanislaus
Denair,7.250%,7.875%,1.125%,0.000%,Stanislaus
El Viejo,7.250%,7.875%,1.125%,0.000%,Stanislaus
Empire,7.250%,7.875%,1.125%,0.000%,Stanislaus
Hickman,7.250%,7.875%,1.125%,0.000%,Stanislaus
Hughson,7.250%,7.875%,1.125%,0.000%,Stanislaus
Keyes,7.250%,7.875%,1.125%,0.000%,Stanislaus
Knights Ferry,7.250%,7.875%,1.125%,0.000%,Stanislaus
La Grange,7.250%,7.875%,1.125%,0.000%,Stanislaus
Modesto,7.250%,7.875%,1.125%,0.000%,Stanislaus
Newman,7.250%,7.875%,1.125%,0.000%,Stanislaus
Oakdale,7.250%,8.375%,1.125%,0.000%,Stanislaus
Patterson,7.250%,7.875%,1.125%,0.000%,Stanislaus
Riverbank,7.250%,7.875%,1.125%,0.000%,Stanislaus
Salida,7.250%,7.875%,1.125%,0.000%,Stanislaus
Turlock,7.250%,7.875%,1.125%,0.000%,Stanislaus
Valley Home,7.250%,7.875%,1.125%,0.000%,Stanislaus
Waterford,7.250%,7.875%,1.125%,0.000%,Stanislaus
Westley,7.250%,7.875%,1.125%,0.000%,Stanislaus
Westside,7.250%,7.875%,1.125%,0.000%,Stanislaus
East Nicolaus,7.250%,7.250%,0.000%,0.000%,Sutter
Live Oak,7.250%,7.250%,0.000%,0.000%,Sutter
Meridian,7.250%,7.250%,0.000%,0.000%,Sutter
Nicolaus,7.250%,7.250%,0.000%,0.000%,Sutter
Pleasant Grove,7.250%,7.250%,0.000%,0.000%,Sutter
Rio Oso,7.250%,7.250%,0.000%,0.000%,Sutter
Robbins,7.250%,7.250%,0.000%,0.000%,Sutter
Sutter,7.250%,7.250%,0.000%,0.000%,Sutter
Trowbridge,7.250%,7.250%,0.000%,0.000%,Sutter
Yuba City,7.250%,7.250%,0.000%,0.000%,Sutter
Corning,7.250%,7.750%,0.000%,0.500%,Tehama
Flournoy,7.250%,7.250%,0.000%,0.000%,Tehama
Gerber,7.250%,7.250%,0.000%,0.000%,Tehama
Los Molinos,7.250%,7.250%,0.000%,0.000%,Tehama
Manton,7.250%,7.250%,0.000%,0.000%,Tehama
Mill Creek,7.250%,7.250%,0.000%,0.000%,Tehama
Mineral,7.250%,7.250%,0.000%,0.000%,Tehama
Paskenta,7.250%,7.250%,0.000%,0.000%,Tehama
Paynes Creek,7.250%,7.250%,0.000%,0.000%,Tehama
Proberta,7.250%,7.250%,0.000%,0.000%,Tehama
Red Bluff,7.250%,7.500%,0.000%,0.250%,Tehama
Richfield,7.250%,7.250%,0.000%,0.000%,Tehama
Tehama,7.250%,7.250%,0.000%,0.000%,Tehama
Vina,7.250%,7.250%,0.000%,0.000%,Tehama
Big Bar,7.250%,7.250%,0.000%,0.000%,Trinity
Burnt Ranch,7.250%,7.250%,0.000%,0.000%,Trinity
Denny,7.250%,7.250%,0.000%,0.000%,Trinity
Douglas City,7.250%,7.250%,0.000%,0.000%,Trinity
Forest Glen,7.250%,7.250%,0.000%,0.000%,Trinity
Hayfork,7.250%,7.250%,0.000%,0.000%,Trinity
Helena,7.250%,7.250%,0.000%,0.000%,Trinity
Hyampom,7.250%,7.250%,0.000%,0.000%,Trinity
Island Mountain,7.250%,7.250%,0.000%,0.000%,Trinity
Junction City,7.250%,7.250%,0.000%,0.000%,Trinity
Lewiston,7.250%,7.250%,0.000%,0.000%,Trinity
Mad River,7.250%,7.250%,0.000%,0.000%,Trinity
Ruth,7.250%,7.250%,0.000%,0.000%,Trinity
Salyer,7.250%,7.250%,0.000%,0.000%,Trinity
Trinity Center,7.250%,7.250%,0.000%,0.000%,Trinity
Weaverville,7.250%,7.250%,0.000%,0.000%,Trinity
Zenia,7.250%,7.250%,0.000%,0.000%,Trinity
Alpaugh,7.250%,7.750%,0.500%,0.000%,Tulare
Badger,7.250%,7.750%,0.500%,0.000%,Tulare
California Hot Springs,7.250%,7.750%,0.500%,0.000%,Tulare
Camp Kaweah,7.250%,7.750%,0.500%,0.000%,Tulare
Camp Nelson,7.250%,7.750%,0.500%,0.000%,Tulare
Cutler,7.250%,7.750%,0.500%,0.000%,Tulare
Dinuba,7.250%,8.500%,0.500%,0.750%,Tulare
Ducor,7.250%,7.750%,0.500%,0.000%,Tulare
Earlimart,7.250%,7.750%,0.500%,0.000%,Tulare
East Porterville,7.250%,7.750%,0.500%,0.000%,Tulare
Exeter,7.250%,7.750%,0.500%,0.000%,Tulare
Farmersville,7.250%,8.750%,0.500%,1.000%,Tulare
Giant Forest,7.250%,7.750%,0.500%,0.000%,Tulare
Goshen,7.250%,7.750%,0.500%,0.000%,Tulare
Ivanhoe,7.250%,7.750%,0.500%,0.000%,Tulare
Johnsondale,7.250%,7.750%,0.500%,0.000%,Tulare
Kaweah,7.250%,7.750%,0.500%,0.000%,Tulare
Kings Canyon National Park,7.250%,7.750%,0.500%,0.000%,Tulare
Lemoncove,7.250%,7.750%,0.500%,0.000%,Tulare
Lindsay,7.250%,8.750%,0.500%,1.000%,Tulare
Linnell,7.250%,7.750%,0.500%,0.000%,Tulare
London,7.250%,7.750%,0.500%,0.000%,Tulare
Mineral King,7.250%,7.750%,0.500%,0.000%,Tulare
Mooney,7.250%,7.750%,0.500%,0.000%,Tulare
Orosi,7.250%,7.750%,0.500%,0.000%,Tulare
Pixley,7.250%,7.750%,0.500%,0.000%,Tulare
Plainview,7.250%,7.750%,0.500%,0.000%,Tulare
Poplar,7.250%,7.750%,0.500%,0.000%,Tulare
Porterville,7.250%,8.250%,0.500%,0.500%,Tulare
Posey,7.250%,7.750%,0.500%,0.000%,Tulare
Richgrove,7.250%,7.750%,0.500%,0.000%,Tulare
Sequoia National Park,7.250%,7.750%,0.500%,0.000%,Tulare
Springville,7.250%,7.750%,0.500%,0.000%,Tulare
Strathmore,7.250%,7.750%,0.500%,0.000%,Tulare
Sultana,7.250%,7.750%,0.500%,0.000%,Tulare
Tagus Ranch,7.250%,7.750%,0.500%,0.000%,Tulare
Terra Bella,7.250%,7.750%,0.500%,0.000%,Tulare
Three Rivers,7.250%,7.750%,0.500%,0.000%,Tulare
Tipton,7.250%,7.750%,0.500%,0.000%,Tulare
Town Center,7.250%,7.750%,0.500%,0.000%,Tulare
Traver,7.250%,7.750%,0.500%,0.000%,Tulare
Tulare,7.250%,8.250%,0.500%,0.500%,Tulare
Visalia,7.250%,8.500%,0.500%,0.750%,Tulare
Waukena,7.250%,7.750%,0.500%,0.000%,Tulare
Woodlake,7.250%,8.750%,0.500%,1.000%,Tulare
Woodville,7.250%,7.750%,0.500%,0.000%,Tulare
Yettem,7.250%,7.750%,0.500%,0.000%,Tulare
Big Oak Flat,7.250%,7.250%,0.000%,0.000%,Tuolumne
Chinese Camp,7.250%,7.250%,0.000%,0.000%,Tuolumne
Columbia,7.250%,7.250%,0.000%,0.000%,Tuolumne
Dardanelle,7.250%,7.250%,0.000%,0.000%,Tuolumne
Groveland,7.250%,7.250%,0.000%,0.000%,Tuolumne
Jamestown,7.250%,7.250%,0.000%,0.000%,Tuolumne
Long Barn,7.250%,7.250%,0.000%,0.000%,Tuolumne
Mather,7.250%,7.250%,0.000%,0.000%,Tuolumne
Mi-Wuk Village,7.250%,7.250%,0.000%,0.000%,Tuolumne
Moccasin,7.250%,7.250%,0.000%,0.000%,Tuolumne
Pinecrest,7.250%,7.250%,0.000%,0.000%,Tuolumne
Sonora,7.250%,7.750%,0.000%,0.500%,Tuolumne
Soulsbyville,7.250%,7.250%,0.000%,0.000%,Tuolumne
Standard,7.250%,7.250%,0.000%,0.000%,Tuolumne
Stanislaus,7.250%,7.250%,0.000%,0.000%,Tuolumne
Strawberry,7.250%,7.250%,0.000%,0.000%,Tuolumne
Tuolumne,7.250%,7.250%,0.000%,0.000%,Tuolumne
Twain Harte,7.250%,7.250%,0.000%,0.000%,Tuolumne
Camarillo,7.250%,7.250%,0.000%,0.000%,Ventura
Casitas Springs,7.250%,7.250%,0.000%,0.000%,Ventura
Fillmore,7.250%,7.250%,0.000%,0.000%,Ventura
Lake Sherwood,7.250%,7.250%,0.000%,0.000%,Ventura
Meiners Oaks,7.250%,7.250%,0.000%,0.000%,Ventura
Montalvo(Ventura),7.250%,7.750%,0.000%,0.500%,Ventura
Moorpark,7.250%,7.250%,0.000%,0.000%,Ventura
Naval(Port Hueneme),7.250%,7.750%,0.000%,0.500%,Ventura
Newbury Park(Thousand Oaks),7.250%,7.250%,0.000%,0.000%,Ventura
Nyeland Acres,7.250%,7.250%,0.000%,0.000%,Ventura
Oak Park,7.250%,7.250%,0.000%,0.000%,Ventura
Oak View,7.250%,7.250%,0.000%,0.000%,Ventura
Ojai,7.250%,7.250%,0.000%,0.000%,Ventura
Oxnard,7.250%,7.750%,0.000%,0.500%,Ventura
Piru,7.250%,7.250%,0.000%,0.000%,Ventura
Point Mugu,7.250%,7.250%,0.000%,0.000%,Ventura
Port Hueneme,7.250%,7.750%,0.000%,0.500%,Ventura
Santa Paula,7.250%,8.250%,0.000%,1.000%,Ventura
Santa Rosa Valley,7.250%,7.250%,0.000%,0.000%,Ventura
Saticoy,7.250%,7.250%,0.000%,0.000%,Ventura
Simi Valley,7.250%,7.250%,0.000%,0.000%,Ventura
Somis,7.250%,7.250%,0.000%,0.000%,Ventura
Thousand Oaks,7.250%,7.250%,0.000%,0.000%,Ventura
Ventura,7.250%,7.750%,0.000%,0.500%,Ventura
Westlake Village(Thousand Oaks),7.250%,7.250%,0.000%,0.000%,Ventura
Broderick(West Sacramento),7.250%,8.000%,0.000%,0.750%,Yolo
Brooks,7.250%,7.250%,0.000%,0.000%,Yolo
Bryte(West Sacramento),7.250%,8.000%,0.000%,0.750%,Yolo
Capay,7.250%,7.250%,0.000%,0.000%,Yolo
Clarksburg,7.250%,7.250%,0.000%,0.000%,Yolo
Davis,7.250%,8.250%,0.000%,1.000%,Yolo
Dunnigan,7.250%,7.250%,0.000%,0.000%,Yolo
El Macero,7.250%,7.250%,0.000%,0.000%,Yolo
Esparto,7.250%,7.250%,0.000%,0.000%,Yolo
Guinda,7.250%,7.250%,0.000%,0.000%,Yolo
Knights Landing,7.250%,7.250%,0.000%,0.000%,Yolo
Madison,7.250%,7.250%,0.000%,0.000%,Yolo
Rumsey,7.250%,7.250%,0.000%,0.000%,Yolo
West Sacramento,7.250%,8.000%,0.000%,0.750%,Yolo
Winters,7.250%,7.250%,0.000%,0.000%,Yolo
Woodland,7.250%,8.000%,0.000%,0.750%,Yolo
Yolo,7.250%,7.250%,0.000%,0.000%,Yolo
Zamora,7.250%,7.250%,0.000%,0.000%,Yolo
Beale A.F.B.,7.250%,7.250%,0.000%,0.000%,Yuba
Browns Valley,7.250%,7.250%,0.000%,0.000%,Yuba
Brownsville,7.250%,7.250%,0.000%,0.000%,Yuba
Camp Beale,7.250%,7.250%,0.000%,0.000%,Yuba
Camptonville,7.250%,7.250%,0.000%,0.000%,Yuba
Challenge,7.250%,7.250%,0.000%,0.000%,Yuba
Dobbins,7.250%,7.250%,0.000%,0.000%,Yuba
Linda,7.250%,7.250%,0.000%,0.000%,Yuba
Loma Rica,7.250%,7.250%,0.000%,0.000%,Yuba
Marysville,7.250%,8.250%,0.000%,1.000%,Yuba
Olivehurst,7.250%,7.250%,0.000%,0.000%,Yuba
Oregon House,7.250%,7.250%,0.000%,0.000%,Yuba
Rackerby,7.250%,7.250%,0.000%,0.000%,Yuba
Smartsville,7.250%,7.250%,0.000%,0.000%,Yuba
Strawberry Valley,7.250%,7.250%,0.000%,0.000%,Yuba
Wheatland,7.250%,7.750%,0.000%,0.500%,Yuba
Woodleaf,7.250%,7.250%,0.000%,0.000%,Yuba
      CSV
    end
  end
end