namespace :make_ipc_manf do
    desc 'Import '
    task import: :environment do
      all_manf.each do |manf|
        unless Make.exists?(lpc_manf: manf)
        Make.update(
        lpc_manf: manf
        ) 
        p manf
        end
      end
    end
  
    def all_manf
      ["HARLEY-DAV",
       "INDIAN"
       ]
    end
  end
  