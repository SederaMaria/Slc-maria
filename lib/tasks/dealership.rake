namespace :dealership do
  
  desc "Upload access_id to dealerships"
  task upload_access_ids:  :environment do
    puts "Started adding access ids"
    Dealership.find_each do |dl|
      dl.update_column(:name, dl.name.strip)
    end

    CSV.parse(access_ids, headers: true) do |row|
      dealership = Dealership.where('lower(name) = ?', row["Dealer Name"].downcase).first 

      if dealership.present?
        dealership.access_id = row["AccessId"]
        if dealership.save
          puts "Successfully added access_id: #{row["AccessId"]} -> #{row["Dealer Name"]}"
        else
          puts "Failed to upload access_id: #{row["AccessId"]} for #{row["Dealer Name"]}"
        end
      end
    end
    puts "Finished"
  end


  desc "set previously_approved_dealership"
  task set_previously_approved_dealership:  :environment do
    Dealership.all.each do |dl|
      deal_fee_val = 0
      deal_fee_val = 20000 if dl.name.downcase == "certified motors" 
      dl.update(deal_fee_cents: deal_fee_val)
    end
  end

  desc "set deal_fee_cents"
  task set_deal_fee_cents:  :environment do
    Dealership.where(active: true).each do |dl|
      dl.update(previously_approved_dealership: true)
    end
  end


  desc "set remit_to_dealer_calculation"
  task set_remit_to_dealer_calculation:  :environment do
    Dealership.all.each do |dl|
      val = 1
      val = 2 if dl.name.downcase == "certified motors" 
      dl.update(remit_to_dealer_calculation_id: val)
    end
  end

  desc 'Update dealerships with missing access_id'
  task 'set_missing_access_ids':  :environment do
    puts 'Started access_id update'
    Dealership.find_each do |dl|
      dl.update_column(:name, dl.name.strip)
    end

    CSV.parse(access_ids_more, headers: true) do |row|
      dealership = Dealership.where('lower(name) = ?', row['Dealer Name'].downcase).first 

      if dealership.present?
        dealership.access_id = row['AccessId']
        dealership.updated_at = DateTime.now
        if dealership.save
          puts "Successfully set access_id #{row["AccessId"]} for #{row["Dealer Name"]}"
        else
          puts "Failed to set access_id #{row["AccessId"]} for #{row["Dealer Name"]}"
        end
      end
    end
    puts 'Finished'
  end  

  def access_ids
    <<-CSV
AccessId,Dealer Name
1,American Motorcycle Trading Co
2,BuyYourMotorcycle.com
3,CAPITAL CITY CYCLES
4,DREAM MACHINES OF TEXAS
6,Southern Truck and Equipment Inc.
7,"Kevin Powell's Performance Motorsports, Inc"
8,"Kevin Powell's Triad Powersports, Inc"
9,"Kevin Powell's Forsyth Motorsports, Inc"
10,LUCKY U CYCLES LLC
11,Motor Export Experts
12,Stormy Hill Harley-Davidson
13,Boneyard Cycles LLC
14,Carolina V-Twin
15,Dream Machines Indian Motorcycle
16,Elite Motor Sports
17,Faith Cycles LLC
18,"Hopper Motorplex, Inc"
19,Legend Cycles
20,"Main Street Powersports, LLC"
21,Tesch Auto & Cycle
22,Darin Grooms Auto Sports Inc
23,Indian Motorcycle of Fort Lauderdale
24,MJB Sales LTD
25,LAKELAND HARLEY-DAVIDSON
26,Fort Bragg Harley Davidson
27,Indian Motorcycle of Panama City Beach
28,Iron Eagle Cycles
29,First Florida Motor Sports
30,FLIP MY CYCLE
31,EC Cars
32,Pure Powersports
33,The Cycle Ward
34,Cycle Exchange LLC
35,FL-Sunshine-MC
36,17 Customs
37,MC Cycles LLC
38,No Limit Motorsports LLC
39,Southwest Cycle
40,Wild Child Cycles
41,Greg's Custom Cycle Works Inc
42,Velocity Motorworx
43,Family Powersports
44,TRG Motor Company
45,GMS United
46,"AZ Auto RV, LLC"
47,The Car Connection LLC
48,DALLAS HARLEY DAVIDSON
49,Team Extreme Motorcars
50,Gator Harley-Davidson
51,Classic Iron
52,DV Auto Center
53,BURKES REPO OUTLET
54,Jaguar Power Sports
55,Southwest Superbikes Inc.
56,North Ridge Custom Cycles
57,Top Gear Inc
58,SpinWurkz
59,469 Cycle Shop
60,Maverick Harley-Davidson
61,Roanoke Valley Harley-Davidson
62,Midwest Motorcycle of Daytona
63,Lone Star Yamaha
64,Paradise Power Sports
65,Seaside Powersports
66,C&C Thunder
67,Indian Motorcycle of Savannah
68,Strokers Dallas
69,Desperado Harley-Davidson
70,Ronnie's V-Twin Cycles
71,1 Stop Harleys
72,Byron Power Sports
73,D & A Cycles
74,D & D Discount Motorcycles
75,Myrtle Beach Harley-Davidson
76,Patagonia Motorcycles
77,Re-Cycle Sales
78,St. Pete Powersports
79,The Harley-Davidson Shop at the Beach
80,WOW Motorcycles
81,Cycle Boss Motorsports
82,Highway 12 Motorsports
83,Sierra Cycles
84,Freedom Powersports Decatur
85,Freedom Marine
86,Freedom Powersports Dallas
87,Freedom Powersports Farmers Branch
88,Cycle Nation of Canton
89,Cycle Nation of Huntsville
90,Cycle Nation of McDonough
91,Freedom Powersports Weatherford
92,Freedom Powersports Johnson County
93,Freedom Powersports Hurst
94,Republic of Texas Indian Motorcycle
95,Freedom Powersports Fort Worth
96,Big Tex Indian Motorcycle
97,Atlanta Highway Indian Motorcycle
98,Show Low Motorsports
99,Southeast Motorcycle
101,Rock City Cycles
102,All Out Powersports
103,Soul Rebel Cycles
104,Ol' Red's Motorcycles
105,Smoky Mountain Harley-Davidson
106,Dixie Cycle
107,Southeast Motorsports
108,Alvarado Autoplex
109,Paris Harley-Davidson
110,Jim's Motorcycle Service
111,Motorcycle Wholesale Outlet
112,Independent Motorsports
113,Action Powersports
114,Fox Cycle Sales
115,Approval Powersports
116,EuroTek OKC
117,Buckeye City Motorsports
118,Sooner Indian Motorcycle
119,Harley-Davidson of Pensacola
120,Arlington Motorsports
121,Cycle World of Athens
122,Parkway Motors
123,Star City Powersports
124,Thornton's Motorcycle Sales
125,Integrity Cycles
126,Mobile Bay Harley-Davidson
127,Smokin' Harley-Davidson
128,Harley-Davidson of Cool Springs
129,Emerald Coast Harley-Davidson
130,MotorCentral
131,Chunky River Harley-Davidson
132,Chicago Cycles & Motorsports
133,Music City Indian Motorcycle
134,America's Motorsports Madison
135,Lumberjack Harley-Davidson
136,Top Spoke LLC
137,Classic Harley-Davidson
138,69 Motors
139,Harley-Davidson of Waco
140,Lucky Penny Cycles
141,Mad Boar Harley-Davidson
142,Roughneck Harley-Davidson
144,Speed Zone Motorsports of Gadsden
145,Speed Zone Motorsports of Oxford
146,Texarkana Harley-Davidson
147,Texas Harley-Davidson
148,Texoma Harley-Davidson
149,TNT Auto Sales and Services Inc.
150,Winebrenner's American Motorcycles
152,Gatto Cycle Shop
153,Dead End Cycles
154,COZIAHR HARLEY-DAVIDSON
155,BUMPUS HARLEY-DAVIDSON OF MURFREESBORO
156,EVOLUTION POWERSPORTS
157,HIGH PLAINS HARLEY-DAVIDSON
158,HATTIESBURG CYCLES
159,LIMA HARLEY-DAVIDSON
160,MR. MOTORHEAD
161,PRIMO MOTORCYCLES
162,Vice Powersports
167,FORT THUNDER HARLEY-DAVIDSON
168,BUSTED NUCKLE
169,Bad Boys Toyss
170,MAD RIVER HARLEY-DAVIDSON
171,SOUTH MAIN IRON
172,SUNSHINE AUTO
173,MISSION CITY INDIAN MOTORCYCLE
174,H Town Motors
175,PINUP BAGGERS
176,Rubber City Harley-Davidson
177,Rock-N-Roll City Harley-Davidson
178,Adventure Harley-Davidson
179,Haus of Trikes & Bikes
180,Speedway Harley-Davidson
181,American Classic Motors
182,V-Twin Partners
183,Wind in Wheels
184,CENTRAL TEXAS HARLEY-DAVIDSON
187,POWDER KEG HARLEY-DAVIDSON
189,CHAMPION MOTORSPORTS
191,TEXAS HOGS MOTORCYCLES
193,OUTPOST MOTORSPORTS
194,INCREDIBLE CAR CREDIT
195,"WOODS FUN CENTER, LLC"
196,OSBORN USA
197,"HD MOTORCYCLES, INC"
198,JOKER POWERSPORTS LLC
199,WARREN HARLEY DAVIDSON
200,STINGER HARLEY-DAVIDSON
201,IMOTORSPORTS ORLANDO
204,FREEDOM CYCLES
205,DOC'S HARLEY-DAVIDSON
206,Big #1 Motorsports
207,Cosmo's Indian Motorcycle
208,D & D Performance
209,Next Ride Largo
210,Next Ride Tampa
211,BOSWELL'S COUNTRY ROADS HARLEY-DAVIDSON
212,Boswell's Harley-Davidson Nashville
213,Boswell's Ring of Fire Harley-Davidson
214,Destination Powersports
216,Sam's Motorcycles
217,RideNow Powersports Forney
218,L.O.F. Motorsports
219,Tifton Harley-Davidson
220,Trojan Powersports
222,Wilmington Powersports
223,Sky Powersports North Orlando
224,Patriot Harley-Davidson
225,FREEDOM HARLEY-DAVIDSON
226,INDIAN MOTORCYCLE OF FORT HOOD
228,RUCKER AUTO & CYCLE SALES
231,FRS POWERSPORTS
232,DESTINATION HONDA
233,SUPERSTITION HARLEY-DAVIDSON
234,ROUTE 30 HARLEY-DAVIDSON
235,BENNETT POWERSPORTS
236,PRIME MOTORCYCLES
237,Gaither Powersports and Trailer Sales
238,MIDTOWN MOTORS
239,Desert Thunder Motorsports
240,Gear Up Motorsports LLC
241,Dream Cycles USA
243,Hooligan Cycles
244,DFW REDLINE RACERS
245,PLANET POWERSPORTS
246,Lone Star Indian Motorcycles
247,Myers-Duren Harley-Davidson
248,Reed's Motorcycles
249,Stu's Motorcycles
250,CKTRAM MOTORS
253,COWBOY HARLEY-DAVIDSON OF AUSTIN
255,Redstone Harley-Davidson
256,Harley-Davidson of Montgomery
257,"Clemmons Motorcycles, Inc"
258,CYCLE CENTER OF DENTON
260,BARIL CYCLE CONNECTION
263,BBV POWERSPORTS
265,Santa Fe Harley-Davidson
267,BLUE RIDGE HARLEY-DAVIDSON
269,"METROLINA MOTORSPORTS OF KM, INC"
271,GINA'S MOTORSPORTS OF MONEE
273,Indian Motorcycle of Oklahoma City
274,LEGENDS CYCLE OF MISSOURI
275,Longshore Cycle Center
276,210 Cycles
278,"THE CHOPPER GALLERY, INC."
279,OC Motorcycle
281,Sir Pete's Back Alley Motorcycles
282,Town and Country Sports Center
283,Dream Machines of San Antonio
284,French Valley Flying Circus
285,Bumpus Harley-Davidson of Memphis
286,Attitude Alley Motorcycle Company
287,Major Powersports
288,"LIFESTYLE CUSTOM CYCLES, LLC."
289,Tecumseh Harley-Davidson Shop
291,Freeride Motorcycles
292,Reno Harley-Davidson
293,Harley-Davidson of Yuba City
294,Redwood Harley-Davidson
295,"AMERICAN V TWIN, INC."
296,Worth Harley-Davidson
297,COWBOY'S ALAMO CITY HARLEY-DAVIDSON
298,"SUN SPORTS CYCLE AND WATERCRAFT, INC"
299,Seminole Powersports
300,Iron Power Sports
301,HD American Cycles
302,Bumpus Harley-Davidson of Jackson
303,"DREAM RIDES VEHICLE SALES, INC."
305,COLEMAN POWERSPORTS FALLS CHURCH
306,IMOTORSPORTS INC
307,Fort Worth Harley-Davidson
308,Bumpus Harley-Davidson Shop of Collierville
309,Black Bear Harley-Davidson
310,Mother Road Harley-Davidson
311,Colonial Harley Davidson Inc
312,Coleman PowerSports (Woodbridge)
313,"CYCLES, SKIS & ATVS"
314,SoFlo Powersports
316,M & S HARLEY-DAVIDSON
317,Broward Motorsports of Treasure Coast
319,BROWARD MOTORSPORTS OF FT LAUDERDALE
320,WIND RIVER HARLEY DAVIDSON
321,THUNDER TOWER WEST HARLEY-DAVIDSON
323,Lake Erie Harley-Davidson
324,Full Trottle Motorsports (Dimondale)
327,COWBOY HARLEY-DAVIDSON OF BEAUMONT
328,East Carolina Powersports
331,Corpus Christi Harley-Davidson
333,Boca Powersports
334,EBENEZERS MOTORSPORTS LLC
335,TEMECULA HARLEY-DAVIDSON
336,Full Throttle Powersports (Lowell)
337,Cycle World
338,Team Charolette Motorsports
339,LONGHORN HARLEY-DAVIDSON
340,Max Motorsports
341,Wild West Harley Davidson
342,Monroe Motorsports
343,Powersports of Palm Beach
344,Sky Powersports Sanford
345,Gainesville Harley-Davidson & Buell
346,Iron Steed Harley-Davidson
347,CORONADO BEACH HARLEY-DAVIDSON
348,CERTIFIED MOTOR COMPANY
349,GAINESVILLE HARLEY-DAVIDSON
350,BW Motorsports
351,Baton Rouge Harley-Davidson
352,Hammond Harley-Davidson
353,Abernathy Harley-Davidson
354,Fortunauto 13
355,Bair's Powersports
356,"HARLEY-DAVIDSON OF WASHINGTON, DC"
357,Harley-Davidson of Greenville
358,Midland Powersports
359,Mike Bruno's Bayou Country Harley-Davidson
360,Bootlegger Harley-Davidson
361,KNOXVILLE HARLEY-DAVIDSON
362,EAGLE MOTORCYCLES
363,Desert Wind Harley-Davidson
364,SIERRA STEEL HARLEY-DAVIDSON
366,CRYSTAL RIVER HARLEY - DAVIDSON
367,War Horse Harley-Davidson
368,Coastal Indian Motorcycle
369,Suzuki Powersports of Carol Stream
370,Appalachian Harley-Davidson
371,Oakland Harley-Davidson
372,Gibson Motor Works
373,JP Superbikes
374,Western Reserve Harley-Davidson
375,RIDERS HARLEY-DAVIDSON
376,PIT STOP CYCLE SHOP
377,Indian Motorcycle of Charlotte
379,All American Harley-Davidson
380,Spartan Cycle
381,Huntington Beach Harley-Davidson
382,Riverside Harley-Davidson
383,G & S Suzuki
384,Queen City Harley-Davidson
385,Capital Honda Powersports
386,Sparky's American Motorcycles
387,RUHNKE'S XTREME CYCLES LLC
388,Mike Bruno's Northshore Harley-Davidson
389,Laredo Harley-Davidson
390,MORAMOTO- TAMPA
391,MORAMOTO- PINELLAS PARK
392,Savannah Harley-Davidson
393,A&T Cycles
394,Pocono Mountain Harley-Davidson
395,Neal Ketner Motors
396,D & N Auto Sales
397,Sky Powersports Lakeland
399,FORT BRAGG HARLEY-DAVIDSON
400,Hamilton Harley-Davidson
401,Republic Harley-Davidson
402,"M & K Auto Sales, Inc"
403,Self Insurance
404,NATCHEZ TRACE HARLEY-DAVIDSON
    CSV
  end

  def access_ids_more
    <<-CSV
AccessId,Dealer Name
480,3 State Harley-Davidson
438,5th Gear Cycle
469,Altus Motorsports
455,Bald Eagle Harley-Davidson
445,Bikemax LLC
457,Boondox Motorsports
466,"Brandt's Harley-Davidson"
462,Budz Chrome Nutz, LLC
437,"Busch's Chop Shop"
491,Caliente Harley-Davidson
484,Car Corral
448,Car Place
348,Certified Motors
489,Chattahoochee Harley-Davidson
257,Clemmons Motorcycles
452,"Cox's Harley-Davidson"
488,Credit Starter Cycle
478,D&D American Performance LLC
487,Dream Machines Motorsports
450,"Eagle's Nest Harley-Davidson"
492,ERTLE Powersports
444,Freedom Cycles, Inc.
481,Good Sense RV & Motors
461,Harley-Davidson Bayside
475,Harley-Davidson of Rocklin
449,Harley-Davidson of Sacramento
476,Head Motor Company
482,Honda Of The Ozarks
443,Honda Powersports of Crofton
483,Hot Metal Harley-Davidson
493,KDZ Kustoms LLC
468,"King's Kustoms Motorcycles"
453,LA Cycle Sports
486,Los Angeles Harley-Davidson
460,Lucky Penny Cycles Houston
447,Memphis Finest Auto
465,Mid America Harley-Davidson
471,Midnight Motors
473,Motor City Harley-Davidson
440,Motorsports4u.com
454,New Castle Harley-Davidson
439,Palmer Motorsports Inc
485,Raging Bull Harley-Davidson
442,"Reiman's Harley-Davidson"
451,Riding High Harley-Davidson
459,Roaring Toyz Inc
446,"Roughin' It, Inc"
456,Santos Cycles
464,Shawnee Honda Powersports
458,Stillwater Powersports
470,TEK Motorsports
467,Three Rivers Harley-Davidson
441,Timms Harley Davidson
474,Twisted Bike & Auto
472,TX Toy Sales
479,Whippet Motorsports
490,Youngblood Powersports
    CSV
  end
  
end