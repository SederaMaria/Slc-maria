module ActiveAdmin::LeaseCalculatorHelper
  include ActionView::Helpers::NumberHelper
  # Builds an array that can be passed to `options_for_select`
  # [
  #   ["FLSTC", "FLSTC", {"data-maximum-term-length"=>60}],
  #   ["FLSTF", "FLSTF", {"data-maximum-term-length"=>60}],
  #   ["FLSTSC", "FLSTSC", {"data-maximum-term-length"=>60}],
  #   ...
  # ]
  def model_years_for_make_and_year_for_select(asset_make:, asset_year:)
    model_names = []
    if asset_make.present?
      asset_make = Make.find_by_id(asset_make).name if is_integer(asset_make)
      # @data-maximum-term-length priority: (1 is top most)
      # (1) specific_maximum_term_length
      # (2) maximum_term_length_per_year, then
      # (3) group_maximum_term_length
      model_names = ModelYear.active.active_nada_rough.for_make_name(asset_make).for_year(asset_year).
        select("model_years.id,
                makes.name AS make_name,
                model_years.name AS model_year_name,
                model_years.maximum_term_length AS specific_maximum_term_length,
                model_groups.maximum_term_length AS group_maximum_term_length,
                model_groups.maximum_term_length_per_year").
        order("model_groups.sort_index asc, model_year_name asc").
        map do |record|
          @maximum_terget_month_for_group = 0
          if !record&.maximum_term_length_per_year.nil? && record&.maximum_term_length_per_year != 'null'
            if (record&.maximum_term_length_per_year&.keys&.any? { |s| s.include?('-') })
              term_month_groups = record&.maximum_term_length_per_year&.keys&.grep(/-/)
                for month_group in term_month_groups do
                  term_lenth_range_array = month_group.to_s.split('-')
                  if asset_year.to_i.between? term_lenth_range_array[0].to_i, term_lenth_range_array[1].to_i
                    @maximum_terget_month_for_group = record.maximum_term_length_per_year.try(:[], month_group.to_s)
                  end
              end
            end
          end
          [
            record.model_year_name, 
            record.model_year_name, 
            {"data-maximum-term-length" => (record.specific_maximum_term_length || record.maximum_term_length_per_year&.presence&.try(:[], asset_year.to_s) || @maximum_terget_month_for_group > 0 && @maximum_terget_month_for_group || record.group_maximum_term_length)},
            {"data-overall-maximum-term-length" => record.group_maximum_term_length }
          ]
        end
    else
      model_names
    end
  end

  def is_integer(asset_make)
    /\A[-+]?\d+\z/ === asset_make
  end

  def participation_markup_for_select(credit_tier:)
    return nil unless credit_tier.present?
    max_limit = (credit_tier.split[1].to_i <= 5) ? 3 : 0      
    options_for_select((0..max_limit).step(0.25).to_a.map{|perc| [number_to_percentage(perc, precision: 2), perc]})
  end

  def terms_for_calculator_radio_buttons(maximum_term_length: 60)
    LeaseCalculator::TERMS.map {|term| ["#{term} Months",term, {disabled: (term > maximum_term_length)}]}
  end

  def display_stipulations?(calculator)
    calculator.lease_application && %w(approved approved_with_contingencies).include?(calculator.lease_application.credit_status)
  end

  def mileage_tier_collection(with_tier: nil)
    all_current = MileageTier.order(:position).map(&:display_name)
    if with_tier.present? && !with_tier.presence_in(all_current)
      name = "#{with_tier} (Obsolete)"
      all_current << [name, name, { 'data-unsubmittable' => true, 'selected' => true }]
    end
    all_current.sort do |a, b|
      a = with_tier if a.is_a? Array
      b = with_tier if b.is_a? Array
      a <=> b
    end
  end
end
