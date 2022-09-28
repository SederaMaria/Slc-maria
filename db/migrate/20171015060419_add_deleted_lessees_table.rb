class AddDeletedLesseesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :deleted_colessees do |t|
      t.string :first_name                 
      t.string :middle_name                
      t.string :last_name                  
      t.string :suffix                     
      t.string :encrypted_ssn              
      t.date :date_of_birth              
      t.string :mobile_phone_number        
      t.string :home_phone_number          
      t.string :drivers_license_id_number  
      t.string :drivers_license_state      
      t.string :email_address              
      t.string :employment_details         
      t.integer :home_address_id            
      t.integer :mailing_address_id         
      t.integer :employment_address_id      
      t.integer :lease_application_id      
      t.string :encrypted_ssn_iv           
      t.integer :at_address_years           
      t.integer :at_address_months          
      t.decimal :monthly_mortgage           
      t.integer :home_ownership             
      t.date :drivers_licence_expires_at 
      t.string :employer_name              
      t.integer :time_at_employer_years     
      t.integer :time_at_employer_months    
      t.string :job_title                  
      t.integer :employment_status          
      t.string :employer_phone_number      
      t.decimal :gross_monthly_income       
      t.decimal :other_monthly_income       
      t.integer :highest_fico_score        
      t.references :lease_application
      t.timestamps
    end
  end
end
