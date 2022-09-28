namespace :file_attachment do
    desc "Seed File Attachment type"
    task seed_types: :environment do
      if FileAttachmentType.all.empty?
        seed_type_data.each do |data|
            FileAttachmentType.create(data)
        end
      end
    end

    private

    def seed_type_data
        [
          { label: 'ACH Verification' },
          { label: 'Funding Request Form' },
          { label: 'Income Verification' },
          { label: 'Lease Package' },
          { label: 'VIN Verification' }
        ]
      end


  end