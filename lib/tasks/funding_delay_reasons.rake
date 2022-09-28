namespace :funding_delays do
    desc 'Import Funding Delay Reasons Into Table'
    task import: :environment do
      FundingDelayReason.delete_all
      all_delays.each do |reason|
        unless FundingDelayReason.exists?(reason: reason)
        FundingDelayReason.create(
          reason:         reason
        ) 
        p reason
        end
      end
    end
  
    def all_delays
      ["ACH Authorization Form - Form not filled out by the lessee. Please see notes below on how to correct. ",
       "ACH Authorization Form - Form not signed by the lessee and/or co-lessee. Please provide completed ACH Form with original signature(s) for funding.",
       "ACH Form - Lessee cannot change payment dates. Please provide updated original ACH Form. Lessee can call Servicing at 844-390-0717, Option 2 to speak about changing their payment dates in the future.",
       "ACH Form - Please specify if account number provided is Checking or Savings.", 
       "Acknowledgements - Acknowledgements Form is not signed by the lessee and/or co-lessee. Must have original signature. Cannot accept a copy.", 
       "Acknowledgements - No copy of the Acknowledgements Form was provided. Must have original signature. Cannot accept a copy.", 
       "BOS - BOS needs to be signed and name printed by dealership, not lessee.", 
       "BOS - BOS not signed and name printed by dealer representative.", 
       "BOS - BOS proivded does not match lease agreement. Please provide BOS provided with funding package.", 
       "BOS - No copy of the signed SLC Trust BOS provided.", 
       "Contingency – Awaiting Payoff check in our office for previous Speed Leasing Account.", 
       "Contingency – Proof of Payoff still needed to clear Underwriting. Please see notes below.", 
       "Contingent per Underwriting. Please see notes below.", 
       "Driver License - No copy of the co-lessee’s non-expired driver license (or state issued ID) provided.", 
       "Driver License - No copy of the lessee’s non-expired driver license provided. No permits accepted.", 
       "Driver License - Please provide a clear copy of the co-lessee’s non-expired driver license or state issued ID.", 
       "Driver License - Please provide a clear copy of the lessee’s non-expired driver license.", 
       "Driver License - Lessee Driver License is expired. Please provide non-expired driver licence.", 
       "Driver License - Co- Lessee Driver License or state issued ID is expired. Please provide a non-expired driver license or state issued ID.", 
       "Email - Email address was invalid. Please provide valid email address.", 
       "Email - No email address provided for the lessee. Please provide a valid email address.", 
       "Email - Email address provide is illegible. Please provide valid email address.", 
       "GAP Contract - Price on GAP Contract does not match Lease Page 3. Please correct GAP Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "GAP Contract - SLC Trust needs to be listed as the Financial Institution/Lien Holder. Please provide a signed copy of changes made and also send to Warranty Company.", 
       "GAP Contract - Term on GAP Contract does not match Lease Page 3. Please correct GAP Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "GAP Contract – The GAP Contract needs to be in the lessee’s name with SLC Trust listed as the Lien Holder / Financial Institution.", 
       "Insurance - Coverage is too low. Limits must be at least 100k/300k/50k (or $300k CSL) with maximum deductibles of $1,000. Please refer to Insurance Requirements sheet provided in the Funding Package for proper insurance requirements.", 
       "Insurance - Effective date is in the future. Cannot clear funding until insurance is in effect.", 
       "Insurance – Lessee is not listed on insurance provided. Please have lessee added as an insured driver or retain insurance in their name. Please provide verification. Limits must be at least 100k/300k/50k (or $300k CSL) with maximum deductibles of $1,000. SLC Trust must be listed as Lien Holder/Loss payee/Lessor AND Additional Interest/Additional Insured. Please refer to Insurance Requirements sheet provided in the Funding Package for proper insurance requirements.", 
       "Insurance – Lessee’s state is different on insurance than the lease pack. Please verify correct address.", 
       "Insurance - Lien Holder/Loss Payee and Additional Interest/Additional Insured should list SLC Trust and not Speed Leasing Company LLC. Please refer to Insurance Requirements sheet provided inof the Funding Package for proper insurance requirements.", 
       "Insurance – No effective or expiration dates present. ", 
       "Insurance - No policy number provided on insurance provided.", 
       "Insurance - No proof of insurance provided. Limits must be at least 100k/300k/50k (or $300k CSL) with maximum deductibles of $1,000. SLC Trust must be listed as Lien Holder/Loss payee/Lessor AND Additional Interest/Additional Insured. Please refer to Insurance Requirements sheet provided in the Funding Package for proper insurance requirements.", 
       "Insurance - SLC Trust is only listed as Lien Holder/Loss Payee/Lessor. SLC Trust must also be listed as Additional Interest/Additional Insured. Please refer to Insurance Requirements sheet provided ain the Funding Package for proper insurance requirements.", 
       "Lease - Funding Package remained in delay past the lessee first payment date. Funding will be reduced by one (1) full month payment. Please have lessee pay this payment to you, should you choose. If Funding Package remains in delay for more than 30 days after receipt in office, the Package will expire. New documents will need to be requested from Underwriting.", 
       "Lease - Amendment needed. Please see notes below. Once signed by lessee and/or co-lessee, email to funding@speedleasing.com.", 
       "Lease - Entire Funding Package is a copy. Please provide original signatures on required forms and send to SLC Trust. ", "Lease - Last page of the lease is not signed by the dealership. Please sign page with lessee(s) signature(s) and email to funding@speedleasing.com", 
       "Lease - Page 3 - the GAP Contract box is checked but no copy of the GAP Contract was provided. Please provide a signed copy of the Contract with SLC Trust as the Financial Institution/Lien Holder.", 
       "Lease - Page 3 - the Pre-Paid Maintenance box is checked but no copy of the Pre-Paid Maintenance Contract was provided. Please provide a signed copy of the Contract with SLC Trust as the Financial Institution/Lien Holder.", 
       "Lease - Page 3 - the Service Contract box is checked but no copy of the Service Contract was provided. Please provide a signed copy of the Contract with SLC Trust as the Financial Institution/Lien Holder.", 
       "Lease - Page 3 - the Tire & Wheel box is checked but no copy of the Tire & Wheel Contract was provided. Please provide a signed copy of the Contract withSLC Trust as the Financial Institution/Lien Holder.", 
       "Lease - Page 3 is not signed by the lessee and/or co-lessee. Must have original signature. Cannot accept a copy.", 
       "Lease Application - Page 2 is not signed by the lessee/co-lessee. Must have original signature. Cannot accept a copy.", "Lease Application - Please verify markups on Lease Application. New POR or POSS may be required. ", 
       "MCR - No copy of the Motorcycle Condition Report was provided.", "MCR - The Motorcycle Condition Report  does not have the notes section completed. ", 
       "MCR - The Motorcycle Condition Report does not have tread reading completed. ", 
       "MCR - The Motorcycle Condition Report is not filled out.", "MCR - The Motorcycle Condition Report is not signed by the Dealership.", 
       "MCR - The Motorcycle Condition Report is not signed by the lessee and/or co-lessee. ", 
       "Miscellaneous. Please see notes below.", 
       "ODS - No copy of the Odometer Disclosure Form provided.", 
       "ODS - Odometer Disclosure Statement is not signed by the Dealership.", 
       "ODS - Odometer Disclosure Statement is not signed by the lessee.", 
       "ODS- Odometer Statement has markups on the form. Please provide signed copy with no markups. If the odometer reading on the funding package is incorrect, please contact Funding at 844-390-0717 for assistance.", 
       "Page(s) of the lease are missing. Please see notes below.", 
       "Pre-Paid Maintenance Contract - Price on Pre-Paid Maintenance Contract does not match Lease Page 3. Please correct Pre-Paid Maintenance Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "Pre-Paid Maintenance Contract - SLC Trust needs to be listed as the Financial Institution/Lien Holder. Please provide a signed copy of changes made and also send to Warranty Company.", 
       "Pre-Paid Maintenance Contract - Term on Pre-Paid Maintenance Contract does not match Lease Page 3. Please correct Pre-Paid Maintenance Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "Pre-Paid Maintenance Contract – The Pre-Paid Maintenance Contract needs to be in the lessee’s name with SLC Trust listed as the Lien Holder / Financial Institution.", 
       "References - Need four (4) references for the lessee (first name, last name, city, state, and unique phone number). Lessee and/or colessee can be used as a reference.", 
       "References - Information missing on one or more references. Please see notes below.", 
       "Service Contract - Price on Service Contract does not match Lease Page 3. Please correct Service Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "Service Contract - SLC Trust needs to be listed as the Financial Institution/Lien Holder. Please provide a signed copy of changes made and also send to Warranty Company.", 
       "Service Contract - Term on Service Contract does not match Lease Page 3. Please correct Service Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.",
       "Service Contract – The Service Contract needs to be in the lessee’s name with SLC Trust listed as the Lien Holder / Financial Institution.", 
       "Tire & Wheel Contract - Price on Tire & Wheel Contract does not match Lease Page 3. Please correct Tire & Wheel Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "Tire & Wheel Contract - SLC Trust needs to be listed as the Financial Institution/Lien Holder. Please provide a signed copy of changes made and also send to Warranty Company.", 
       "Tire & Wheel Contract - Term on Tire & Wheel Contract does not match Lease Page 3. Please correct Tire & Wheel Contract and resubmit for funding. If Lease Agreemement is incorrect, please contact the Funding Department at 844-390-0717 for assistance.", 
       "Tire & Wheel Contract – The Tire & Wheel Contract needs to be in the lessee’s name with SLC Trust listed as the Lien Holder / Financial Institution.", 
       "Title - No copy of the Arizona Lease Agreement was provided.", 
       "Title – No copy of the Arizona Lessor Authorization Form.", 
       "Title - No copy of the Indiana Form ST-108E was provided", 
       "Title – No copy of the Indiana Statement of Existing Lease Form.", 
       "Title - No copy of the North Carolina MVR-608 Form provided.", 
       "Title - No copy of the North Carolina Registration Form MVR-330 provided.", 
       "Title - No copy of the Title & Lien Guarantee Form provided. Please sign and return Guarantee included in funding package.", 
       "Title - Corresponding title documents are missing. Please see notes below.", 
       "Title - No copy of the title application was provided", 
       "Title - The lien holder should list SLC LienCo LLC as lien holder. Please refer to title application (or example) provided in the Funding Package.", 
       "Title - The title application is not correct. SLC Trust needs to be listed as the owner."]
    end
  end
  