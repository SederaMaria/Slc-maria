require 'roo'

class ModelYearService

  def initialize(file:)
    @import_file = file
  end

  def import_model_years
    begin
      xlsx = Roo::Spreadsheet.open(@import_file)
      xlsx.each_with_pagename do |name, sheet|
        sheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
          next if row.eql?(sheet.first_row)
          company = row[0] ? row[0].value : ''
          year = row[2] ? row[2].value : ''
          model_group = row[3] ? row[3].value : ''
          name = row[4] ? row[4].value : ''
          original_msrp = row[13] ? row[13].value : ''
          nada_rough = row[14] ? row[14].value : ''
          nada_avg_retail = row[16] ? row[16].value : ''

          make = Make.where("lower(name) =  ?", company.downcase).first_or_create({
                                                               vin_starts_with: '1HD'
                                                           })

          model_group = ModelGroup.where(ModelGroup.arel_table[:name].matches("%#{model_group}%")).first_or_create({
                                                                                                                       make: make,
                                                                                                                       name: model_group.titleize,
                                                                                                                   })

          model_group.model_years.where(name: name, year: year).first_or_create({
                                                                                    nada_rough: nada_rough.to_money,
                                                                                    nada_avg_retail: nada_avg_retail.to_money,
                                                                                    original_msrp: original_msrp.to_money
                                                                                })
        end
      end
      Admins::ModelYearFacade.new.recalculate_residuals
      {notice: 'Model Years were successfully import.'}
    rescue
      {alert: 'Model Years were not successfully import.'}
    end
  end
end