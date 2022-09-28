namespace :prenote do
  desc "Seed Codes"
  task seed_codes: :environment do
    file_path = "#{Rails.root}/db/Prenotes.xlsx"
    workbook = Roo::Spreadsheet.open(file_path)
    worksheets = workbook.sheets
    seed_noc_codes(worksheets.first, workbook)
    seed_return_codes(worksheets.last, workbook)
  end

  private

  def seed_noc_codes sheet, workbook
    NachaNocCode.destroy_all
    workbook.sheet(sheet).each_row_streaming(offset: 1) do |row|
      NachaNocCode.create(code: row[0].value, description: row[1].value)
    end
  end

  def seed_return_codes sheet, workbook
    RemoteCheckReturnCode.destroy_all
    workbook.sheet(sheet).each_row_streaming(offset: 1) do |row|
      RemoteCheckReturnCode.create(code: row[0].value, description: row[1].value)
    end
  end
  
end
