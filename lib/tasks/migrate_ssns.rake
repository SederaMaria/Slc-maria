namespace :lessee do
  desc "Migrate SSNs to CryptKeeper"
  task migrate_to_cryptkeeper: :environment do
    #add a scope to ensure we don't re-encrypt on top of already migrated Lessees
    Lessee.where(ssn: nil).where.not(encrypted_ssn: nil).where.not(encrypted_ssn_iv: nil).find_each do |l|
      begin
        p "Migrating SSN for #{l.name_with_middle_initial} (#{l.id})"
        l.ssn = l.ed_ssn
        l.save!
        p 'Finished'
      rescue => e
        p "**** --> ERROR migrating #{l.name_with_middle_initial} (#{l.id}) **** (#{e.class} - #{e.to_s})"
      end
    end
  end
  desc 'Reset Lessee SSNs'
  task reset_ssn: :environment do
    Lessee.update_all(ssn: nil)
  end

  desc 'Re-encrypt SSNs'
  task reencrypt_ssns: :environment do
    Rake::Task['lessee:reset_ssn'].invoke
    Rake::Task['lessee:migrate_to_cryptkeeper'].invoke
  end

end
