namespace :tax_jurisdictions do
  namespace :alabama do
    desc 'Import/Update Alabama Tax Jurisdictions and Rules'
    task import: :environment do
      CSV.parse(alabama_data, headers: true) do |row|
        find_or_create_alabama_county_tax_rule(row)
        find_or_create_alabama_tax_jurisdiction(row)
      end
    end

    def find_or_create_alabama_tax_jurisdiction(zipcode_data)
      name            = zipcode_data['ZipCode']
      us_state        = 'alabama'
      state_tax_rule  = alabama_state_rule
      county_tax_rule = find_or_create_alabama_county_tax_rule(zipcode_data)
      local_tax_rule  = find_or_create_alabama_local_tax_rule(zipcode_data)

      TaxJurisdiction.where(name: name, us_state: us_state).first_or_create(
        state_tax_rule:  state_tax_rule,
        county_tax_rule: county_tax_rule,
        local_tax_rule: local_tax_rule,
        )
    end

    def find_or_create_alabama_county_tax_rule(zipcode_data)
      county_name              = "#{zipcode_data['County']} AL"
      sales_tax_percentage     = zipcode_data['CountyRate'].to_f
      up_front_tax_percentage  = zipcode_data['CountyRate'].to_f
      cash_down_tax_percentage = zipcode_data['CountyRate'].to_f

      Rails.logger.info("Setting Rates for #{county_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.county.where(name: county_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def find_or_create_alabama_local_tax_rule(zipcode_data)
      city_name                = "#{zipcode_data['City']} LOCAL"
      sales_tax_percentage     = zipcode_data['CityRate'].to_f
      up_front_tax_percentage  = zipcode_data['CityRate'].to_f
      cash_down_tax_percentage = zipcode_data['CityRate'].to_f

      Rails.logger.info("Setting Rates for #{city_name}: (#{sales_tax_percentage}, #{up_front_tax_percentage}, #{cash_down_tax_percentage})")

      TaxRule.local.where(name: city_name).first_or_create(
        sales_tax_percentage:     sales_tax_percentage,
        up_front_tax_percentage:  up_front_tax_percentage,
        cash_down_tax_percentage: cash_down_tax_percentage
      )
    end

    def alabama_state_rule
      @alabama_state_rule ||= TaxRule.state.where(name: 'Alabama').first_or_create(
        sales_tax_percentage:     1.5,
        up_front_tax_percentage:  1.5,
        cash_down_tax_percentage: 1.5
      )
    end

    def alabama_data
      <<-CSV
State,ZipCode,City,County,TotalRate,StateRate,CityRate,CountyRate
AL,36003,Autaugaville,Autauga,1.50%,1.50%,0.00%,0.00%
AL,36006,Billingsley,Autauga,1.50%,1.50%,0.00%,0.00%
AL,36008,Booth,Autauga,1.50%,1.50%,0.00%,0.00%
AL,36749,Jones,Autauga,1.50%,1.50%,,0.00%
AL,36051,Marbury,Autauga,1.50%,1.50%,0.00%,0.00%
AL,36066,Prattville,Autauga,2.50%,1.50%,1.00%,0.00%
AL,36067,Prattville,Autauga,2.50%,1.50%,1.00%,0.00%
AL,36068,Prattville,Autauga,2.50%,1.50%,1.00%,0.00%
AL,36507,Bay Minette,Baldwin,4.75%,1.50%,1.50%,1.75%
AL,36511,Bon Secour,Baldwin,3.25%,1.50%,,1.75%
AL,36526,Daphne,Baldwin,4.25%,1.50%,1.00%,1.75%
AL,36530,Elberta,Baldwin,3.25%,1.50%,,1.75%
AL,36532,Fairhope,Baldwin,3.25%,1.50%,,1.75%
AL,36533,Fairhope,Baldwin,3.25%,1.50%,,1.75%
AL,36535,Foley,Baldwin,4.25%,1.50%,1.00%,1.75%
AL,36536,Foley,Baldwin,4.25%,1.50%,1.00%,1.75%
AL,36542,Gulf Shores,Baldwin,4.75%,1.50%,1.50%,1.75%
AL,36547,Gulf Shores,Baldwin,4.75%,1.50%,1.50%,1.75%
AL,36549,Lillian,Baldwin,3.25%,1.50%,,1.75%
AL,36550,Little River,Baldwin,3.25%,1.50%,,1.75%
AL,36551,Loxley,Baldwin,5.25%,1.50%,2.00%,1.75%
AL,36555,Magnolia Springs,Baldwin,3.25%,1.50%,,1.75%
AL,36559,Montrose,Baldwin,3.25%,1.50%,,1.75%
AL,36561,Orange Beach,Baldwin,4.25%,1.50%,1.00%,1.75%
AL,36562,Perdido,Baldwin,3.25%,1.50%,,1.75%
AL,36564,Point Clear,Baldwin,3.25%,1.50%,,1.75%
AL,36567,Robertsdale,Baldwin,4.25%,1.50%,1.00%,1.75%
AL,36574,Seminole,Baldwin,3.25%,1.50%,,1.75%
AL,36576,Silverhill,Baldwin,3.25%,1.50%,,1.75%
AL,36527,Spanish Fort,Baldwin,4.00%,1.50%,0.75%,1.75%
AL,36577,Spanish Fort,Baldwin,4.00%,1.50%,0.75%,1.75%
AL,36578,Stapleton,Baldwin,3.25%,1.50%,,1.75%
AL,36579,Stockton,Baldwin,3.25%,1.50%,,1.75%
AL,36580,Summerdale,Baldwin,5.25%,1.50%,2.00%,1.75%
AL,36016,Clayton,Barbour,1.50%,1.50%,0.00%,0.00%
AL,36017,Clio,Barbour,3.50%,1.50%,2.00%,0.00%
AL,36027,Eufaula,Barbour,3.00%,1.50%,1.50%,0.00%
AL,36072,Eufaula,Barbour,3.00%,1.50%,1.50%,0.00%
AL,36048,Louisville,Barbour,1.50%,1.50%,0.00%,0.00%
AL,35034,Brent,Bibb,2.50%,1.50%,1.00%,0.00%
AL,35035,Brierfield,Bibb,1.50%,1.50%,,0.00%
AL,35042,Centreville,Bibb,1.50%,1.50%,0.00%,0.00%
AL,35074,Green Pond,Bibb,1.50%,1.50%,,0.00%
AL,36793,Lawley,Bibb,1.50%,1.50%,,0.00%
AL,36792,Randolph,Bibb,1.50%,1.50%,,0.00%
AL,35184,West Blocton,Bibb,1.50%,1.50%,0.00%,0.00%
AL,35188,Woodstock,Bibb,1.50%,1.50%,0.00%,0.00%
AL,35013,Allgood,Blount,4.50%,1.50%,3.00%,0.00%
AL,35031,Blountsville,Blount,2.00%,1.50%,0.50%,0.00%
AL,35049,Cleveland,Blount,3.50%,1.50%,2.00%,0.00%
AL,35079,Hayden,Blount,1.50%,1.50%,0.00%,0.00%
AL,35097,Locust Fork,Blount,1.50%,1.50%,0.00%,0.00%
AL,35121,Oneonta,Blount,3.50%,1.50%,2.00%,0.00%
AL,35133,Remlap,Blount,1.50%,1.50%,,0.00%
AL,36029,Fitzpatrick,Bullock,1.50%,1.50%,,0.00%
AL,36053,Midway,Bullock,1.50%,1.50%,0.00%,0.00%
AL,36061,Perote,Bullock,1.50%,1.50%,,0.00%
AL,36089,Union Springs,Bullock,1.50%,1.50%,0.00%,0.00%
AL,36015,Chapman,Butler,1.50%,1.50%,,0.00%
AL,36030,Forest Home,Butler,1.50%,1.50%,,0.00%
AL,36033,Georgiana,Butler,1.50%,1.50%,0.00%,0.00%
AL,36037,Greenville,Butler,2.50%,1.50%,1.00%,0.00%
AL,36456,Mc Kenzie,Butler,1.50%,1.50%,0.00%,0.00%
AL,36250,Alexandria,Calhoun,3.75%,1.50%,,2.25%
AL,36201,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36202,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36204,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36205,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36206,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36207,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36210,Anniston,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36253,Bynum,Calhoun,3.75%,1.50%,,2.25%
AL,36254,Choccolocco,Calhoun,3.75%,1.50%,,2.25%
AL,36257,De Armanville,Calhoun,3.75%,1.50%,,2.25%
AL,36260,Eastaboga,Calhoun,3.75%,1.50%,,2.25%
AL,36265,Jacksonville,Calhoun,4.25%,1.50%,0.50%,2.25%
AL,36271,Ohatchee,Calhoun,6.75%,1.50%,3.00%,2.25%
AL,36203,Oxford,Calhoun,5.75%,1.50%,2.00%,2.25%
AL,36272,Piedmont,Calhoun,4.25%,1.50%,0.50%,2.25%
AL,36277,Weaver,Calhoun,3.75%,1.50%,0.00%,2.25%
AL,36279,Wellington,Calhoun,3.75%,1.50%,,2.25%
AL,36855,Five Points,Chambers,1.50%,1.50%,0.00%,
AL,36862,Lafayette,Chambers,1.50%,1.50%,0.00%,
AL,36863,Lanett,Chambers,1.50%,1.50%,0.00%,
AL,36854,Valley,Chambers,2.50%,1.50%,1.00%,
AL,35959,Cedar Bluff,Cherokee,1.50%,1.50%,,
AL,35960,Centre,Cherokee,1.50%,1.50%,,
AL,35973,Gaylesville,Cherokee,1.50%,1.50%,,
AL,35983,Leesburg,Cherokee,1.50%,1.50%,,
AL,36275,Spring Garden,Cherokee,1.50%,1.50%,,
AL,35045,Clanton,Chilton,1.50%,1.50%,,
AL,35046,Clanton,Chilton,1.50%,1.50%,,
AL,35085,Jemison,Chilton,1.50%,1.50%,,
AL,36750,Maplesville,Chilton,1.50%,1.50%,,
AL,36790,Stanton,Chilton,1.50%,1.50%,,
AL,35171,Thorsby,Chilton,1.50%,1.50%,,
AL,36091,Verbena,Chilton,1.50%,1.50%,,
AL,36904,Butler,Choctaw,2.00%,1.50%,0.50%,0.00%
AL,36908,Gilbertown,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36910,Jachin,Choctaw,1.50%,1.50%,,0.00%
AL,36912,Lisman,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36913,Melvin,Choctaw,1.50%,1.50%,,0.00%
AL,36915,Needham,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36916,Pennington,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36919,Silas,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36921,Toxey,Choctaw,1.50%,1.50%,0.00%,0.00%
AL,36922,Ward,Choctaw,1.50%,1.50%,,0.00%
AL,36501,Alma,Clarke,1.50%,1.50%,,
AL,36727,Campbell,Clarke,1.50%,1.50%,,
AL,36515,Carlton,Clarke,1.50%,1.50%,,
AL,36524,Coffeeville,Clarke,1.50%,1.50%,,
AL,36436,Dickinson,Clarke,1.50%,1.50%,,
AL,36446,Fulton,Clarke,1.50%,1.50%,,
AL,36540,Gainestown,Clarke,1.50%,1.50%,,
AL,36451,Grove Hill,Clarke,1.50%,1.50%,,
AL,36545,Jackson,Clarke,1.50%,1.50%,,
AL,36762,Morvin,Clarke,1.50%,1.50%,,
AL,36784,Thomasville,Clarke,1.50%,1.50%,,
AL,36482,Whatley,Clarke,1.50%,1.50%,,
AL,36251,Ashland,Clay,1.50%,1.50%,,
AL,36255,Cragford,Clay,1.50%,1.50%,,
AL,36258,Delta,Clay,1.50%,1.50%,,
AL,35082,Hollins,Clay,1.50%,1.50%,,
AL,36266,Lineville,Clay,1.50%,1.50%,,
AL,36267,Millerville,Clay,1.50%,1.50%,,
AL,36261,Edwardsville,Cleburne,1.50%,1.50%,,
AL,36262,Fruithurst,Cleburne,1.50%,1.50%,,
AL,36264,Heflin,Cleburne,1.50%,1.50%,,
AL,36269,Muscadine,Cleburne,1.50%,1.50%,,
AL,36273,Ranburne,Cleburne,1.50%,1.50%,,
AL,36323,Elba,Coffee,1.50%,1.50%,0.00%,0.00%
AL,36330,Enterprise,Coffee,1.50%,1.50%,0.00%,0.00%
AL,36331,Enterprise,Coffee,1.50%,1.50%,0.00%,0.00%
AL,36346,Jack,Coffee,1.50%,1.50%,,0.00%
AL,36453,Kinston,Coffee,1.50%,1.50%,0.00%,0.00%
AL,36351,New Brockton,Coffee,1.50%,1.50%,0.00%,0.00%
AL,35616,Cherokee,Colbert,1.50%,1.50%,0.000%,0.00%
AL,35646,Leighton,Colbert,1.50%,1.50%,0.000%,0.00%
AL,35661,Muscle Shoals,Colbert,1.88%,1.50%,0.375%,0.00%
AL,35662,Muscle Shoals,Colbert,1.88%,1.50%,0.375%,0.00%
AL,35660,Sheffield,Colbert,3.50%,1.50%,2.000%,0.00%
AL,35674,Tuscumbia,Colbert,1.50%,1.50%,,0.00%
AL,36429,Brooklyn,Conecuh,1.50%,1.50%,,0.00%
AL,36432,Castleberry,Conecuh,4.50%,1.50%,3.00%,0.00%
AL,36401,Evergreen,Conecuh,1.50%,1.50%,0.00%,0.00%
AL,36454,Lenox,Conecuh,1.50%,1.50%,,0.00%
AL,36473,Range,Conecuh,1.50%,1.50%,,0.00%
AL,36475,Repton,Conecuh,1.50%,1.50%,0.00%,0.00%
AL,36026,Equality,Coosa,1.50%,1.50%,,0.00%
AL,35072,Goodwater,Coosa,2.50%,1.50%,1.00%,0.00%
AL,35089,Kellyton,Coosa,1.50%,1.50%,0.00%,0.00%
AL,35136,Rockford,Coosa,1.50%,1.50%,0.00%,0.00%
AL,35183,Weogufka,Coosa,1.50%,1.50%,,0.00%
AL,36420,Andalusia,Covington,1.50%,1.50%,,
AL,36421,Andalusia,Covington,1.50%,1.50%,,
AL,36442,Florala,Covington,1.50%,1.50%,,
AL,36038,Gantt,Covington,1.50%,1.50%,,
AL,36455,Lockhart,Covington,1.50%,1.50%,,
AL,36467,Opp,Covington,1.50%,1.50%,,
AL,36474,Red Level,Covington,1.50%,1.50%,,
AL,36476,River Falls,Covington,1.50%,1.50%,,
AL,36483,Wing,Covington,1.50%,1.50%,,
AL,36009,Brantley,Crenshaw,1.50%,1.50%,,
AL,36028,Dozier,Crenshaw,1.50%,1.50%,,
AL,36034,Glenwood,Crenshaw,1.50%,1.50%,,
AL,36041,Highland Home,Crenshaw,1.50%,1.50%,,
AL,36042,Honoraville,Crenshaw,1.50%,1.50%,,
AL,36049,Luverne,Crenshaw,1.50%,1.50%,,
AL,36062,Petrey,Crenshaw,1.50%,1.50%,,
AL,36071,Rutledge,Crenshaw,1.50%,1.50%,,
AL,35019,Baileyton,Cullman,1.50%,1.50%,,
AL,35033,Bremen,Cullman,1.50%,1.50%,,
AL,35053,Crane Hill,Cullman,1.50%,1.50%,,
AL,35055,Cullman,Cullman,1.50%,1.50%,,
AL,35056,Cullman,Cullman,1.50%,1.50%,,
AL,35057,Cullman,Cullman,1.50%,1.50%,,
AL,35058,Cullman,Cullman,1.50%,1.50%,,
AL,35070,Garden City,Cullman,1.50%,1.50%,,
AL,35077,Hanceville,Cullman,1.50%,1.50%,,
AL,35083,Holly Pond,Cullman,1.50%,1.50%,,
AL,35087,Joppa,Cullman,1.50%,1.50%,,
AL,35098,Logan,Cullman,1.50%,1.50%,,
AL,35179,Vinemont,Cullman,1.50%,1.50%,,
AL,36311,Ariton,Dale,1.50%,1.50%,,
AL,36322,Daleville,Dale,1.50%,1.50%,,
AL,36362,Fort Rucker,Dale,1.50%,1.50%,,
AL,36350,Midland City,Dale,1.50%,1.50%,,
AL,36352,Newton,Dale,1.50%,1.50%,,
AL,36360,Ozark,Dale,1.50%,1.50%,,
AL,36361,Ozark,Dale,1.50%,1.50%,,
AL,36371,Pinckard,Dale,1.50%,1.50%,,
AL,36374,Skipperville,Dale,1.50%,1.50%,,
AL,36759,Marion Junction,Dallas,1.50%,1.50%,,
AL,36761,Minter,Dallas,1.50%,1.50%,,
AL,36767,Orrville,Dallas,1.50%,1.50%,,
AL,36758,Plantersville,Dallas,1.50%,1.50%,,
AL,36773,Safford,Dallas,1.50%,1.50%,,
AL,36775,Sardis,Dallas,1.50%,1.50%,,
AL,36701,Selma,Dallas,1.50%,1.50%,,
AL,36702,Selma,Dallas,1.50%,1.50%,,
AL,36703,Selma,Dallas,1.50%,1.50%,,
AL,35961,Collinsville,De Kalb,1.50%,1.50%,,
AL,35962,Crossville,De Kalb,1.50%,1.50%,,
AL,35963,Dawson,De Kalb,1.50%,1.50%,,
AL,35967,Fort Payne,De Kalb,1.50%,1.50%,,
AL,35968,Fort Payne,De Kalb,1.50%,1.50%,,
AL,35971,Fyffe,De Kalb,1.50%,1.50%,,
AL,35974,Geraldine,De Kalb,1.50%,1.50%,,
AL,35975,Groveoak,De Kalb,1.50%,1.50%,,
AL,35978,Henagar,De Kalb,1.50%,1.50%,,
AL,35981,Ider,De Kalb,1.50%,1.50%,,
AL,35984,Mentone,De Kalb,1.50%,1.50%,,
AL,35986,Rainsville,De Kalb,1.50%,1.50%,,
AL,35988,Sylvania,De Kalb,1.50%,1.50%,,
AL,35989,Valley Head,De Kalb,1.50%,1.50%,,
AL,36020,Coosada,Elmore,1.50%,1.50%,,
AL,36022,Deatsville,Elmore,1.50%,1.50%,,
AL,36024,Eclectic,Elmore,1.50%,1.50%,,
AL,36025,Elmore,Elmore,1.50%,1.50%,,
AL,36045,Kent,Elmore,1.50%,1.50%,,
AL,36054,Millbrook,Elmore,1.50%,1.50%,,
AL,36078,Tallassee,Elmore,1.50%,1.50%,,
AL,36080,Titus,Elmore,1.50%,1.50%,,
AL,36092,Wetumpka,Elmore,1.50%,1.50%,,
AL,36093,Wetumpka,Elmore,1.50%,1.50%,,
AL,36502,Atmore,Escambia,1.50%,1.50%,,
AL,36503,Atmore,Escambia,1.50%,1.50%,,
AL,36504,Atmore,Escambia,1.50%,1.50%,,
AL,36426,Brewton,Escambia,1.50%,1.50%,,
AL,36427,Brewton,Escambia,1.50%,1.50%,,
AL,36441,Flomaton,Escambia,1.50%,1.50%,,
AL,36543,Huxford,Escambia,1.50%,1.50%,,
AL,35952,Altoona,Etowah,1.50%,1.50%,,
AL,35954,Attalla,Etowah,1.50%,1.50%,,
AL,35956,Boaz,Etowah,1.50%,1.50%,,
AL,35901,Gadsden,Etowah,1.50%,1.50%,,
AL,35902,Gadsden,Etowah,1.50%,1.50%,,
AL,35903,Gadsden,Etowah,1.50%,1.50%,,
AL,35904,Gadsden,Etowah,1.50%,1.50%,,
AL,35905,Gadsden,Etowah,1.50%,1.50%,,
AL,35907,Gadsden,Etowah,1.50%,1.50%,,
AL,35972,Gallant,Etowah,1.50%,1.50%,,
AL,35906,Rainbow City,Etowah,1.50%,1.50%,,
AL,35990,Walnut Grove,Etowah,1.50%,1.50%,,
AL,35542,Bankston,Fayette,1.50%,1.50%,,
AL,35545,Belk,Fayette,1.50%,1.50%,,
AL,35546,Berry,Fayette,1.50%,1.50%,,
AL,35555,Fayette,Fayette,1.50%,1.50%,,
AL,35559,Glen Allen,Fayette,1.50%,1.50%,,
AL,35571,Hodges,Franklin,1.50%,1.50%,,
AL,35581,Phil Campbell,Franklin,1.50%,1.50%,,
AL,35582,Red Bay,Franklin,1.50%,1.50%,,
AL,35653,Russellville,Franklin,1.50%,1.50%,,
AL,35654,Russellville,Franklin,1.50%,1.50%,,
AL,35585,Spruce Pine,Franklin,1.50%,1.50%,,
AL,35593,Vina,Franklin,1.50%,1.50%,,
AL,36313,Bellwood,Geneva,1.50%,1.50%,,
AL,36314,Black,Geneva,1.50%,1.50%,,
AL,36316,Chancellor,Geneva,1.50%,1.50%,,
AL,36318,Coffee Springs,Geneva,1.50%,1.50%,,
AL,36340,Geneva,Geneva,1.50%,1.50%,,
AL,36344,Hartford,Geneva,1.50%,1.50%,,
AL,36349,Malvern,Geneva,1.50%,1.50%,,
AL,36477,Samson,Geneva,1.50%,1.50%,,
AL,36375,Slocomb,Geneva,1.50%,1.50%,,
AL,35443,Boligee,Greene,1.50%,1.50%,,
AL,35448,Clinton,Greene,1.50%,1.50%,,
AL,35462,Eutaw,Greene,1.50%,1.50%,,
AL,36740,Forkland,Greene,1.50%,1.50%,,
AL,35469,Knoxville,Greene,1.50%,1.50%,,
AL,35491,West Greene,Greene,1.50%,1.50%,,
AL,35441,Akron,Hale,1.50%,1.50%,,
AL,36744,Greensboro,Hale,1.50%,1.50%,,
AL,35474,Moundville,Hale,1.50%,1.50%,,
AL,36765,Newbern,Hale,1.50%,1.50%,,
AL,36776,Sawyerville,Hale,1.50%,1.50%,,
AL,36310,Abbeville,Henry,3.50%,1.50%,2.00%,
AL,36317,Clopton,Henry,1.50%,1.50%,,
AL,36345,Headland,Henry,1.50%,1.50%,,
AL,36353,Newville,Henry,1.50%,1.50%,,
AL,36373,Shorterville,Henry,1.50%,1.50%,,
AL,36312,Ashford,Houston,1.50%,1.50%,,
AL,36319,Columbia,Houston,1.50%,1.50%,,
AL,36320,Cottonwood,Houston,1.50%,1.50%,,
AL,36321,Cowarts,Houston,1.50%,1.50%,,
AL,36301,Dothan,Houston,1.50%,1.50%,,
AL,36302,Dothan,Houston,1.50%,1.50%,,
AL,36303,Dothan,Houston,1.50%,1.50%,,
AL,36304,Dothan,Houston,1.50%,1.50%,,
AL,36305,Dothan,Houston,1.50%,1.50%,,
AL,36343,Gordon,Houston,1.50%,1.50%,,
AL,36370,Pansey,Houston,1.50%,1.50%,,
AL,36376,Webb,Houston,1.50%,1.50%,,
AL,35740,Bridgeport,Jackson,5.25%,1.50%,3.00%,0.75%
AL,35958,Bryant,Jackson,2.25%,1.50%,,0.75%
AL,35744,Dutton,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35745,Estillfork,Jackson,2.25%,1.50%,,0.75%
AL,35746,Fackler,Jackson,2.25%,1.50%,,0.75%
AL,35966,Flat Rock,Jackson,2.25%,1.50%,,0.75%
AL,35979,Higdon,Jackson,2.25%,1.50%,,0.75%
AL,35751,Hollytree,Jackson,2.25%,1.50%,,0.75%
AL,35752,Hollywood,Jackson,3.25%,1.50%,1.00%,0.75%
AL,35755,Langston,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35764,Paint Rock,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35765,Pisgah,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35766,Princeton,Jackson,2.25%,1.50%,,0.75%
AL,35768,Scottsboro,Jackson,3.00%,1.50%,0.75%,0.75%
AL,35769,Scottsboro,Jackson,3.00%,1.50%,0.75%,0.75%
AL,35771,Section,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35772,Stevenson,Jackson,3.00%,1.50%,0.75%,0.75%
AL,35774,Trenton,Jackson,2.25%,1.50%,,0.75%
AL,35776,Woodville,Jackson,2.25%,1.50%,0.00%,0.75%
AL,35005,Adamsville,Jefferson,5.00%,1.50%,3.50%,0.00%
AL,35006,Adger,Jefferson,1.50%,1.50%,,0.00%
AL,35015,Alton,Jefferson,1.50%,1.50%,,0.00%
AL,35020,Bessemer,Jefferson,1.50%,1.50%,,0.00%
AL,35021,Bessemer,Jefferson,1.50%,1.50%,,0.00%
AL,35022,Bessemer,Jefferson,1.50%,1.50%,,0.00%
AL,35023,Bessemer,Jefferson,1.50%,1.50%,,0.00%
AL,35201,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35202,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35203,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35204,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35205,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35206,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35207,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35208,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35209,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35210,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35211,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35212,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35213,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35214,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35215,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35216,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35217,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35218,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35219,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35220,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35221,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35222,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35223,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35224,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35225,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35226,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35228,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35229,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35230,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35231,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35232,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35233,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35234,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35235,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35236,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35237,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35238,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35240,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35243,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35244,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35245,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35246,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35249,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35253,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35254,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35255,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35259,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35260,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35261,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35263,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35266,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35277,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35278,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35279,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35280,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35281,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35282,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35283,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35285,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35286,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35287,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35288,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35289,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35290,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35291,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35292,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35293,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35294,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35295,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35296,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35297,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35298,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35299,Birmingham,Jefferson,1.50%,1.50%,,0.00%
AL,35036,Brookside,Jefferson,1.50%,1.50%,,0.00%
AL,35041,Cardiff,Jefferson,1.50%,1.50%,,0.00%
AL,35048,Clay,Jefferson,1.50%,1.50%,,0.00%
AL,35060,Docena,Jefferson,1.50%,1.50%,,0.00%
AL,35061,Dolomite,Jefferson,1.50%,1.50%,,0.00%
AL,35062,Dora,Jefferson,1.50%,1.50%,,0.00%
AL,35064,Fairfield,Jefferson,1.50%,1.50%,,0.00%
AL,35068,Fultondale,Jefferson,1.50%,1.50%,,0.00%
AL,35071,Gardendale,Jefferson,1.50%,1.50%,,0.00%
AL,35073,Graysville,Jefferson,1.50%,1.50%,,0.00%
AL,35091,Kimberly,Jefferson,1.50%,1.50%,,0.00%
AL,35094,Leeds,Jefferson,1.50%,1.50%,,0.00%
AL,35111,Mc Calla,Jefferson,1.50%,1.50%,,0.00%
AL,35116,Morris,Jefferson,1.50%,1.50%,,0.00%
AL,35117,Mount Olive,Jefferson,1.50%,1.50%,,0.00%
AL,35118,Mulga,Jefferson,1.50%,1.50%,,0.00%
AL,35119,New Castle,Jefferson,1.50%,1.50%,,0.00%
AL,35123,Palmerdale,Jefferson,1.50%,1.50%,,0.00%
AL,35126,Pinson,Jefferson,1.50%,1.50%,,0.00%
AL,35127,Pleasant Grove,Jefferson,1.50%,1.50%,,0.00%
AL,35139,Sayre,Jefferson,1.50%,1.50%,,0.00%
AL,35142,Shannon,Jefferson,1.50%,1.50%,,0.00%
AL,35172,Trafford,Jefferson,1.50%,1.50%,,0.00%
AL,35173,Trussville,Jefferson,1.50%,1.50%,,0.00%
AL,35180,Warrior,Jefferson,1.50%,1.50%,,0.00%
AL,35181,Watson,Jefferson,1.50%,1.50%,,0.00%
AL,35544,Beaverton,Lamar,1.50%,1.50%,,
AL,35552,Detroit,Lamar,1.50%,1.50%,,
AL,35574,Kennedy,Lamar,1.50%,1.50%,,
AL,35576,Millport,Lamar,1.50%,1.50%,,
AL,35586,Sulligent,Lamar,1.50%,1.50%,,
AL,35592,Vernon,Lamar,1.50%,1.50%,,
AL,35610,Anderson,Lauderdale,1.50%,1.50%,,
AL,35617,Cloverdale,Lauderdale,1.50%,1.50%,,
AL,35630,Florence,Lauderdale,1.50%,1.50%,,
AL,35631,Florence,Lauderdale,1.50%,1.50%,,
AL,35632,Florence,Lauderdale,1.50%,1.50%,,
AL,35633,Florence,Lauderdale,1.50%,1.50%,,
AL,35634,Florence,Lauderdale,1.50%,1.50%,,
AL,35645,Killen,Lauderdale,1.50%,1.50%,,
AL,35648,Lexington,Lauderdale,1.50%,1.50%,,
AL,35652,Rogersville,Lauderdale,1.50%,1.50%,,
AL,35677,Waterloo,Lauderdale,1.50%,1.50%,,
AL,35618,Courtland,Lawrence,1.50%,1.50%,,
AL,35643,Hillsboro,Lawrence,1.50%,1.50%,,
AL,35650,Moulton,Lawrence,1.50%,1.50%,,
AL,35651,Mount Hope,Lawrence,1.50%,1.50%,,
AL,35672,Town Creek,Lawrence,1.50%,1.50%,,
AL,36830,Auburn,Lee,1.50%,1.50%,,
AL,36831,Auburn,Lee,1.50%,1.50%,,
AL,36832,Auburn,Lee,1.50%,1.50%,,
AL,36849,Auburn University,Lee,1.50%,1.50%,,
AL,36852,Cusseta,Lee,1.50%,1.50%,,
AL,36865,Loachapoka,Lee,1.50%,1.50%,,
AL,36801,Opelika,Lee,1.50%,1.50%,,
AL,36802,Opelika,Lee,1.50%,1.50%,,
AL,36803,Opelika,Lee,1.50%,1.50%,,
AL,36804,Opelika,Lee,1.50%,1.50%,,
AL,36870,Phenix City,Lee,1.50%,1.50%,,
AL,36874,Salem,Lee,1.50%,1.50%,,
AL,36877,Smiths Station,Lee,1.50%,1.50%,,
AL,36872,Valley,Lee,1.50%,1.50%,,
AL,36879,Waverly,Lee,1.50%,1.50%,,
AL,35739,Ardmore,Limestone,1.50%,1.50%,,
AL,35611,Athens,Limestone,1.50%,1.50%,,
AL,35612,Athens,Limestone,1.50%,1.50%,,
AL,35613,Athens,Limestone,1.50%,1.50%,,
AL,35614,Athens,Limestone,1.50%,1.50%,,
AL,35615,Belle Mina,Limestone,1.50%,1.50%,,
AL,35742,Capshaw,Limestone,1.50%,1.50%,,
AL,35620,Elkmont,Limestone,1.50%,1.50%,,
AL,35647,Lester,Limestone,1.50%,1.50%,,
AL,35756,Madison,Limestone,1.50%,1.50%,,
AL,35649,Mooresville,Limestone,1.50%,1.50%,,
AL,35671,Tanner,Limestone,1.50%,1.50%,,
AL,36032,Fort Deposit,Lowndes,1.50%,1.50%,,
AL,36040,Hayneville,Lowndes,1.50%,1.50%,,
AL,36047,Letohatchee,Lowndes,1.50%,1.50%,,
AL,36752,Lowndesboro,Lowndes,1.50%,1.50%,,
AL,36785,Tyler,Lowndes,1.50%,1.50%,,
AL,36031,Fort Davis,Macon,1.50%,1.50%,,
AL,36039,Hardaway,Macon,1.50%,1.50%,,
AL,36866,Notasulga,Macon,1.50%,1.50%,,
AL,36075,Shorter,Macon,1.50%,1.50%,,
AL,36083,Tuskegee,Macon,1.50%,1.50%,,
AL,36087,Tuskegee Institute,Macon,1.50%,1.50%,,
AL,36088,Tuskegee Institute,Macon,1.50%,1.50%,,
AL,35741,Brownsboro,Madison,1.50%,1.50%,,
AL,35748,Gurley,Madison,1.50%,1.50%,,
AL,35749,Harvest,Madison,1.50%,1.50%,,
AL,35750,Hazel Green,Madison,1.50%,1.50%,,
AL,35801,Huntsville,Madison,1.50%,1.50%,,
AL,35802,Huntsville,Madison,1.50%,1.50%,,
AL,35803,Huntsville,Madison,1.50%,1.50%,,
AL,35804,Huntsville,Madison,1.50%,1.50%,,
AL,35805,Huntsville,Madison,1.50%,1.50%,,
AL,35806,Huntsville,Madison,1.50%,1.50%,,
AL,35807,Huntsville,Madison,1.50%,1.50%,,
AL,35808,Huntsville,Madison,1.50%,1.50%,,
AL,35809,Huntsville,Madison,1.50%,1.50%,,
AL,35810,Huntsville,Madison,1.50%,1.50%,,
AL,35811,Huntsville,Madison,1.50%,1.50%,,
AL,35812,Huntsville,Madison,1.50%,1.50%,,
AL,35813,Huntsville,Madison,1.50%,1.50%,,
AL,35814,Huntsville,Madison,1.50%,1.50%,,
AL,35815,Huntsville,Madison,1.50%,1.50%,,
AL,35816,Huntsville,Madison,1.50%,1.50%,,
AL,35824,Huntsville,Madison,1.50%,1.50%,,
AL,35893,Huntsville,Madison,1.50%,1.50%,,
AL,35894,Huntsville,Madison,1.50%,1.50%,,
AL,35895,Huntsville,Madison,1.50%,1.50%,,
AL,35896,Huntsville,Madison,1.50%,1.50%,,
AL,35897,Huntsville,Madison,1.50%,1.50%,,
AL,35898,Huntsville,Madison,1.50%,1.50%,,
AL,35899,Huntsville,Madison,1.50%,1.50%,,
AL,35757,Madison,Madison,1.50%,1.50%,,
AL,35758,Madison,Madison,1.50%,1.50%,,
AL,35759,Meridianville,Madison,1.50%,1.50%,,
AL,35760,New Hope,Madison,1.50%,1.50%,,
AL,35761,New Market,Madison,1.50%,1.50%,,
AL,35762,Normal,Madison,1.50%,1.50%,,
AL,35763,Owens Cross Roads,Madison,1.50%,1.50%,,
AL,35767,Ryland,Madison,1.50%,1.50%,,
AL,35773,Toney,Madison,1.50%,1.50%,,
AL,36732,Demopolis,Marengo,1.50%,1.50%,,
AL,36736,Dixons Mills,Marengo,1.50%,1.50%,,
AL,36738,Faunsdale,Marengo,1.50%,1.50%,,
AL,36742,Gallion,Marengo,1.50%,1.50%,,
AL,36745,Jefferson,Marengo,1.50%,1.50%,,
AL,36748,Linden,Marengo,1.50%,1.50%,,
AL,36754,Magnolia,Marengo,1.50%,1.50%,,
AL,36763,Myrtlewood,Marengo,1.50%,1.50%,,
AL,36764,Nanafalia,Marengo,1.50%,1.50%,,
AL,36782,Sweet Water,Marengo,1.50%,1.50%,,
AL,36783,Thomaston,Marengo,1.50%,1.50%,,
AL,35543,Bear Creek,Marion,1.50%,1.50%,,
AL,35548,Brilliant,Marion,1.50%,1.50%,,
AL,35563,Guin,Marion,1.50%,1.50%,,
AL,35564,Hackleburg,Marion,1.50%,1.50%,,
AL,35570,Hamilton,Marion,1.50%,1.50%,,
AL,35594,Winfield,Marion,1.50%,1.50%,,
AL,35950,Albertville,Marshall,1.50%,1.50%,,
AL,35951,Albertville,Marshall,1.50%,1.50%,,
AL,35016,Arab,Marshall,1.50%,1.50%,,
AL,35957,Boaz,Marshall,1.50%,1.50%,,
AL,35964,Douglas,Marshall,1.50%,1.50%,,
AL,35747,Grant,Marshall,1.50%,1.50%,,
AL,35976,Guntersville,Marshall,1.50%,1.50%,,
AL,35980,Horton,Marshall,1.50%,1.50%,,
AL,35175,Union Grove,Marshall,1.50%,1.50%,,
AL,36505,Axis,Mobile,1.50%,1.50%,,
AL,36509,Bayou La Batre,Mobile,1.50%,1.50%,,
AL,36512,Bucks,Mobile,1.50%,1.50%,,
AL,36521,Chunchula,Mobile,1.50%,1.50%,,
AL,36522,Citronelle,Mobile,1.50%,1.50%,,
AL,36523,Coden,Mobile,1.50%,1.50%,,
AL,36525,Creola,Mobile,1.50%,1.50%,,
AL,36528,Dauphin Island,Mobile,1.50%,1.50%,,
AL,36613,Eight Mile,Mobile,1.50%,1.50%,,
AL,36541,Grand Bay,Mobile,1.50%,1.50%,,
AL,36544,Irvington,Mobile,1.50%,1.50%,,
AL,36601,Mobile,Mobile,1.50%,1.50%,,
AL,36602,Mobile,Mobile,1.50%,1.50%,,
AL,36603,Mobile,Mobile,1.50%,1.50%,,
AL,36604,Mobile,Mobile,1.50%,1.50%,,
AL,36605,Mobile,Mobile,1.50%,1.50%,,
AL,36606,Mobile,Mobile,1.50%,1.50%,,
AL,36607,Mobile,Mobile,1.50%,1.50%,,
AL,36608,Mobile,Mobile,1.50%,1.50%,,
AL,36609,Mobile,Mobile,1.50%,1.50%,,
AL,36610,Mobile,Mobile,1.50%,1.50%,,
AL,36611,Mobile,Mobile,1.50%,1.50%,,
AL,36612,Mobile,Mobile,1.50%,1.50%,,
AL,36615,Mobile,Mobile,1.50%,1.50%,,
AL,36616,Mobile,Mobile,1.50%,1.50%,,
AL,36617,Mobile,Mobile,1.50%,1.50%,,
AL,36618,Mobile,Mobile,1.50%,1.50%,,
AL,36619,Mobile,Mobile,1.50%,1.50%,,
AL,36621,Mobile,Mobile,1.50%,1.50%,,
AL,36622,Mobile,Mobile,1.50%,1.50%,,
AL,36625,Mobile,Mobile,1.50%,1.50%,,
AL,36628,Mobile,Mobile,1.50%,1.50%,,
AL,36630,Mobile,Mobile,1.50%,1.50%,,
AL,36633,Mobile,Mobile,1.50%,1.50%,,
AL,36640,Mobile,Mobile,1.50%,1.50%,,
AL,36641,Mobile,Mobile,1.50%,1.50%,,
AL,36644,Mobile,Mobile,1.50%,1.50%,,
AL,36652,Mobile,Mobile,1.50%,1.50%,,
AL,36660,Mobile,Mobile,1.50%,1.50%,,
AL,36663,Mobile,Mobile,1.50%,1.50%,,
AL,36670,Mobile,Mobile,1.50%,1.50%,,
AL,36671,Mobile,Mobile,1.50%,1.50%,,
AL,36675,Mobile,Mobile,1.50%,1.50%,,
AL,36685,Mobile,Mobile,1.50%,1.50%,,
AL,36688,Mobile,Mobile,1.50%,1.50%,,
AL,36689,Mobile,Mobile,1.50%,1.50%,,
AL,36690,Mobile,Mobile,1.50%,1.50%,,
AL,36691,Mobile,Mobile,1.50%,1.50%,,
AL,36693,Mobile,Mobile,1.50%,1.50%,,
AL,36695,Mobile,Mobile,1.50%,1.50%,,
AL,36560,Mount Vernon,Mobile,1.50%,1.50%,,
AL,36568,Saint Elmo,Mobile,1.50%,1.50%,,
AL,36571,Saraland,Mobile,1.50%,1.50%,,
AL,36572,Satsuma,Mobile,1.50%,1.50%,,
AL,36575,Semmes,Mobile,1.50%,1.50%,,
AL,36582,Theodore,Mobile,1.50%,1.50%,,
AL,36590,Theodore,Mobile,1.50%,1.50%,,
AL,36587,Wilmer,Mobile,1.50%,1.50%,,
AL,36425,Beatrice,Monroe,1.50%,1.50%,,
AL,36439,Excel,Monroe,1.50%,1.50%,,
AL,36444,Franklin,Monroe,1.50%,1.50%,,
AL,36445,Frisco City,Monroe,1.50%,1.50%,,
AL,36449,Goodway,Monroe,1.50%,1.50%,,
AL,36457,Megargel,Monroe,1.50%,1.50%,,
AL,36458,Mexia,Monroe,1.50%,1.50%,,
AL,36460,Monroeville,Monroe,1.50%,1.50%,,
AL,36461,Monroeville,Monroe,1.50%,1.50%,,
AL,36462,Monroeville,Monroe,1.50%,1.50%,,
AL,36470,Perdue Hill,Monroe,1.50%,1.50%,,
AL,36471,Peterman,Monroe,1.50%,1.50%,,
AL,36480,Uriah,Monroe,1.50%,1.50%,,
AL,36481,Vredenburgh,Monroe,1.50%,1.50%,,
AL,36013,Cecil,Montgomery,1.50%,1.50%,,
AL,36036,Grady,Montgomery,1.50%,1.50%,,
AL,36043,Hope Hull,Montgomery,1.50%,1.50%,,
AL,36046,Lapine,Montgomery,1.50%,1.50%,,
AL,36052,Mathews,Montgomery,1.50%,1.50%,,
AL,36101,Montgomery,Montgomery,1.50%,1.50%,,
AL,36102,Montgomery,Montgomery,1.50%,1.50%,,
AL,36103,Montgomery,Montgomery,1.50%,1.50%,,
AL,36104,Montgomery,Montgomery,1.50%,1.50%,,
AL,36105,Montgomery,Montgomery,1.50%,1.50%,,
AL,36106,Montgomery,Montgomery,1.50%,1.50%,,
AL,36107,Montgomery,Montgomery,1.50%,1.50%,,
AL,36108,Montgomery,Montgomery,1.50%,1.50%,,
AL,36109,Montgomery,Montgomery,1.50%,1.50%,,
AL,36110,Montgomery,Montgomery,1.50%,1.50%,,
AL,36111,Montgomery,Montgomery,1.50%,1.50%,,
AL,36112,Montgomery,Montgomery,1.50%,1.50%,,
AL,36113,Montgomery,Montgomery,1.50%,1.50%,,
AL,36114,Montgomery,Montgomery,1.50%,1.50%,,
AL,36115,Montgomery,Montgomery,1.50%,1.50%,,
AL,36116,Montgomery,Montgomery,1.50%,1.50%,,
AL,36117,Montgomery,Montgomery,1.50%,1.50%,,
AL,36118,Montgomery,Montgomery,1.50%,1.50%,,
AL,36119,Montgomery,Montgomery,1.50%,1.50%,,
AL,36120,Montgomery,Montgomery,1.50%,1.50%,,
AL,36121,Montgomery,Montgomery,1.50%,1.50%,,
AL,36123,Montgomery,Montgomery,1.50%,1.50%,,
AL,36124,Montgomery,Montgomery,1.50%,1.50%,,
AL,36125,Montgomery,Montgomery,1.50%,1.50%,,
AL,36130,Montgomery,Montgomery,1.50%,1.50%,,
AL,36131,Montgomery,Montgomery,1.50%,1.50%,,
AL,36132,Montgomery,Montgomery,1.50%,1.50%,,
AL,36133,Montgomery,Montgomery,1.50%,1.50%,,
AL,36134,Montgomery,Montgomery,1.50%,1.50%,,
AL,36135,Montgomery,Montgomery,1.50%,1.50%,,
AL,36140,Montgomery,Montgomery,1.50%,1.50%,,
AL,36141,Montgomery,Montgomery,1.50%,1.50%,,
AL,36142,Montgomery,Montgomery,1.50%,1.50%,,
AL,36177,Montgomery,Montgomery,1.50%,1.50%,,
AL,36191,Montgomery,Montgomery,1.50%,1.50%,,
AL,36057,Mount Meigs,Montgomery,1.50%,1.50%,,
AL,36064,Pike Road,Montgomery,1.50%,1.50%,,
AL,36065,Pine Level,Montgomery,1.50%,1.50%,,
AL,36069,Ramer,Montgomery,1.50%,1.50%,,
AL,35619,Danville,Morgan,1.50%,1.50%,,
AL,35601,Decatur,Morgan,1.50%,1.50%,,
AL,35602,Decatur,Morgan,1.50%,1.50%,,
AL,35603,Decatur,Morgan,1.50%,1.50%,,
AL,35609,Decatur,Morgan,1.50%,1.50%,,
AL,35699,Decatur,Morgan,1.50%,1.50%,,
AL,35621,Eva,Morgan,1.50%,1.50%,,
AL,35622,Falkville,Morgan,1.50%,1.50%,,
AL,35640,Hartselle,Morgan,1.50%,1.50%,,
AL,35754,Laceys Spring,Morgan,1.50%,1.50%,,
AL,35670,Somerville,Morgan,1.50%,1.50%,,
AL,35673,Trinity,Morgan,1.50%,1.50%,,
AL,35775,Valhermoso Springs,Morgan,1.50%,1.50%,,
AL,36756,Marion,Perry,1.50%,1.50%,,
AL,36786,Uniontown,Perry,1.50%,1.50%,,
AL,35442,Aliceville,Pickens,1.50%,1.50%,,
AL,35447,Carrollton,Pickens,1.50%,1.50%,,
AL,35461,Ethelsville,Pickens,1.50%,1.50%,,
AL,35466,Gordo,Pickens,1.50%,1.50%,,
AL,35471,Mc Shan,Pickens,1.50%,1.50%,,
AL,35481,Reform,Pickens,1.50%,1.50%,,
AL,36005,Banks,Pike,1.50%,1.50%,,
AL,36010,Brundidge,Pike,1.50%,1.50%,,
AL,36035,Goshen,Pike,1.50%,1.50%,,
AL,36079,Troy,Pike,1.50%,1.50%,,
AL,36081,Troy,Pike,1.50%,1.50%,,
AL,36082,Troy,Pike,1.50%,1.50%,,
AL,36263,Graham,Randolph,1.50%,1.50%,,
AL,36274,Roanoke,Randolph,1.50%,1.50%,,
AL,36276,Wadley,Randolph,1.50%,1.50%,,
AL,36278,Wedowee,Randolph,1.50%,1.50%,,
AL,36280,Woodland,Randolph,1.50%,1.50%,,
AL,36851,Cottonton,Russell,1.50%,1.50%,,
AL,36856,Fort Mitchell,Russell,1.50%,1.50%,,
AL,36858,Hatchechubbee,Russell,1.50%,1.50%,,
AL,36859,Holy Trinity,Russell,1.50%,1.50%,,
AL,36860,Hurtsboro,Russell,1.50%,1.50%,,
AL,36867,Phenix City,Russell,1.50%,1.50%,,
AL,36868,Phenix City,Russell,1.50%,1.50%,,
AL,36869,Phenix City,Russell,1.50%,1.50%,,
AL,36871,Pittsview,Russell,1.50%,1.50%,,
AL,36875,Seale,Russell,1.50%,1.50%,,
AL,35953,Ashville,Saint Clair,1.50%,1.50%,,
AL,35052,Cook Springs,Saint Clair,1.50%,1.50%,,
AL,35054,Cropwell,Saint Clair,1.50%,1.50%,,
AL,35112,Margaret,Saint Clair,1.50%,1.50%,,
AL,35004,Moody,Saint Clair,1.50%,1.50%,,
AL,35120,Odenville,Saint Clair,1.50%,1.50%,,
AL,35125,Pell City,Saint Clair,1.50%,1.50%,,
AL,35128,Pell City,Saint Clair,1.50%,1.50%,,
AL,35131,Ragland,Saint Clair,1.50%,1.50%,,
AL,35135,Riverside,Saint Clair,1.50%,1.50%,,
AL,35146,Springville,Saint Clair,1.50%,1.50%,,
AL,35987,Steele,Saint Clair,1.50%,1.50%,,
AL,35182,Wattsville,Saint Clair,1.50%,1.50%,,
AL,35007,Alabaster,Shelby,1.50%,1.50%,,
AL,35242,Birmingham,Shelby,1.50%,1.50%,,
AL,35040,Calera,Shelby,1.50%,1.50%,,
AL,35043,Chelsea,Shelby,1.50%,1.50%,,
AL,35051,Columbiana,Shelby,1.50%,1.50%,,
AL,35078,Harpersville,Shelby,1.50%,1.50%,,
AL,35080,Helena,Shelby,1.50%,1.50%,,
AL,35114,Maylene,Shelby,1.50%,1.50%,,
AL,35115,Montevallo,Shelby,1.50%,1.50%,,
AL,35124,Pelham,Shelby,1.50%,1.50%,,
AL,35137,Saginaw,Shelby,1.50%,1.50%,,
AL,35143,Shelby,Shelby,1.50%,1.50%,,
AL,35144,Siluria,Shelby,1.50%,1.50%,,
AL,35147,Sterrett,Shelby,1.50%,1.50%,,
AL,35176,Vandiver,Shelby,1.50%,1.50%,,
AL,35178,Vincent,Shelby,1.50%,1.50%,,
AL,35185,Westover,Shelby,1.50%,1.50%,,
AL,35186,Wilsonville,Shelby,1.50%,1.50%,,
AL,35187,Wilton,Shelby,1.50%,1.50%,,
AL,36901,Bellamy,Sumter,1.50%,1.50%,,
AL,36907,Cuba,Sumter,1.50%,1.50%,,
AL,35459,Emelle,Sumter,1.50%,1.50%,,
AL,35460,Epes,Sumter,1.50%,1.50%,,
AL,35464,Gainesville,Sumter,1.50%,1.50%,,
AL,35470,Livingston,Sumter,1.50%,1.50%,,
AL,35477,Panola,Sumter,1.50%,1.50%,,
AL,36925,York,Sumter,1.50%,1.50%,,
AL,35014,Alpine,Talladega,1.50%,1.50%,,
AL,35032,Bon Air,Talladega,1.50%,1.50%,,
AL,35044,Childersburg,Talladega,1.50%,1.50%,,
AL,35096,Lincoln,Talladega,1.50%,1.50%,,
AL,36268,Munford,Talladega,1.50%,1.50%,,
AL,35149,Sycamore,Talladega,1.50%,1.50%,,
AL,35150,Sylacauga,Talladega,1.50%,1.50%,,
AL,35151,Sylacauga,Talladega,1.50%,1.50%,,
AL,35160,Talladega,Talladega,1.50%,1.50%,,
AL,35161,Talladega,Talladega,1.50%,1.50%,,
AL,35010,Alexander City,Tallapoosa,1.50%,1.50%,,
AL,35011,Alexander City,Tallapoosa,1.50%,1.50%,,
AL,36850,Camp Hill,Tallapoosa,1.50%,1.50%,,
AL,36853,Dadeville,Tallapoosa,1.50%,1.50%,,
AL,36256,Daviston,Tallapoosa,1.50%,1.50%,,
AL,36023,East Tallassee,Tallapoosa,1.50%,1.50%,,
AL,36861,Jacksons Gap,Tallapoosa,1.50%,1.50%,,
AL,35440,Abernant,Tuscaloosa,1.50%,1.50%,,
AL,35444,Brookwood,Tuscaloosa,1.50%,1.50%,,
AL,35446,Buhl,Tuscaloosa,1.50%,1.50%,,
AL,35449,Coaling,Tuscaloosa,1.50%,1.50%,,
AL,35452,Coker,Tuscaloosa,1.50%,1.50%,,
AL,35453,Cottondale,Tuscaloosa,1.50%,1.50%,,
AL,35456,Duncanville,Tuscaloosa,1.50%,1.50%,,
AL,35457,Echola,Tuscaloosa,1.50%,1.50%,,
AL,35458,Elrod,Tuscaloosa,1.50%,1.50%,,
AL,35463,Fosters,Tuscaloosa,1.50%,1.50%,,
AL,35468,Kellerman,Tuscaloosa,1.50%,1.50%,,
AL,35473,Northport,Tuscaloosa,1.50%,1.50%,,
AL,35475,Northport,Tuscaloosa,1.50%,1.50%,,
AL,35476,Northport,Tuscaloosa,1.50%,1.50%,,
AL,35478,Peterson,Tuscaloosa,1.50%,1.50%,,
AL,35480,Ralph,Tuscaloosa,1.50%,1.50%,,
AL,35482,Samantha,Tuscaloosa,1.50%,1.50%,,
AL,35401,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35402,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35403,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35404,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35405,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35406,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35407,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35485,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35486,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35487,Tuscaloosa,Tuscaloosa,1.50%,1.50%,,
AL,35490,Vance,Tuscaloosa,1.50%,1.50%,,
AL,35038,Burnwell,Walker,1.50%,1.50%,,
AL,35549,Carbon Hill,Walker,1.50%,1.50%,,
AL,35550,Cordova,Walker,1.50%,1.50%,,
AL,35554,Eldridge,Walker,1.50%,1.50%,,
AL,35063,Empire,Walker,1.50%,1.50%,,
AL,35560,Goodsprings,Walker,1.50%,1.50%,,
AL,35501,Jasper,Walker,1.50%,1.50%,,
AL,35502,Jasper,Walker,1.50%,1.50%,,
AL,35503,Jasper,Walker,1.50%,1.50%,,
AL,35504,Jasper,Walker,1.50%,1.50%,,
AL,35573,Kansas,Walker,1.50%,1.50%,,
AL,35578,Nauvoo,Walker,1.50%,1.50%,,
AL,35579,Oakman,Walker,1.50%,1.50%,,
AL,35580,Parrish,Walker,1.50%,1.50%,,
AL,35130,Quinton,Walker,1.50%,1.50%,,
AL,35584,Sipsey,Walker,1.50%,1.50%,,
AL,35148,Sumiton,Walker,1.50%,1.50%,,
AL,35587,Townley,Walker,1.50%,1.50%,,
AL,36513,Calvert,Washington,1.50%,1.50%,,
AL,36518,Chatom,Washington,1.50%,1.50%,,
AL,36529,Deer Park,Washington,1.50%,1.50%,,
AL,36538,Frankville,Washington,1.50%,1.50%,,
AL,36539,Fruitdale,Washington,1.50%,1.50%,,
AL,36548,Leroy,Washington,1.50%,1.50%,,
AL,36556,Malcolm,Washington,1.50%,1.50%,,
AL,36553,Mc Intosh,Washington,1.50%,1.50%,,
AL,36558,Millry,Washington,1.50%,1.50%,,
AL,36569,Saint Stephens,Washington,1.50%,1.50%,,
AL,36581,Sunflower,Washington,1.50%,1.50%,,
AL,36583,Tibbie,Washington,1.50%,1.50%,,
AL,36584,Vinegar Bend,Washington,1.50%,1.50%,,
AL,36585,Wagarville,Washington,1.50%,1.50%,,
AL,36720,Alberta,Wilcox,1.50%,1.50%,,
AL,36721,Annemanie,Wilcox,1.50%,1.50%,,
AL,36722,Arlington,Wilcox,1.50%,1.50%,,
AL,36723,Boykin,Wilcox,1.50%,1.50%,,
AL,36726,Camden,Wilcox,1.50%,1.50%,,
AL,36728,Catherine,Wilcox,1.50%,1.50%,,
AL,36435,Coy,Wilcox,1.50%,1.50%,,
AL,36741,Furman,Wilcox,1.50%,1.50%,,
AL,36751,Lower Peach Tree,Wilcox,1.50%,1.50%,,
AL,36753,Mc Williams,Wilcox,1.50%,1.50%,,
AL,36766,Oak Hill,Wilcox,1.50%,1.50%,,
AL,36768,Pine Apple,Wilcox,1.50%,1.50%,,
AL,36769,Pine Hill,Wilcox,1.50%,1.50%,,
AL,35540,Addison,Winston,1.50%,1.50%,,
AL,35541,Arley,Winston,1.50%,1.50%,,
AL,35551,Delmar,Winston,1.50%,1.50%,,
AL,35553,Double Springs,Winston,1.50%,1.50%,,
AL,35565,Haleyville,Winston,1.50%,1.50%,,
AL,35572,Houston,Winston,1.50%,1.50%,,
AL,35575,Lynn,Winston,1.50%,1.50%,,
AL,35577,Natural Bridge,Winston,1.50%,1.50%,,
      CSV
    end
  end
end

