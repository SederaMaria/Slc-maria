module ApplicationHelper
  def active_states_for_select
    UsState.active_on_calculator
           .inject([]) do |memo, state|
      state_name   = state.name
      abbreviation = state.abbreviation
      memo << ["#{abbreviation} - #{state_name.titleize}", state_name, { 'data-tax-label' => state.tax_jurisdiction_type.name }] # create the drop down collection
    end.sort { |a, b| a[1] <=> b[1] } # sort alphabetically for good measure and freeze for safe keeping
  end

  def active_abbreviated_states_for_select
    UsState.active_on_calculator
           .inject([]) do |memo, state|
      state_name   = state.name
      abbreviation = state.abbreviation
      memo << ["#{abbreviation} - #{state_name.titleize}", abbreviation, { 'data-tax-label' => state.tax_jurisdiction_type.name }] # create the drop down collection
    end.sort { |a, b| a[1] <=> b[1] } # sort alphabetically for good measure and freeze for safe keeping
  end

  def all_states_for_select
    UsState.all
           .inject([]) do |memo, state|
      state_name   = state.name
      abbreviation = state.abbreviation
      memo << ["#{abbreviation} - #{state_name.titleize}", state_name, { 'data-tax-label' => state.tax_jurisdiction_type.name }] # create the drop down collection
    end.sort { |a, b| a[1] <=> b[1] } # sort alphabetically for good measure and freeze for safe keeping
  end

  def active_states_for_select_api
    UsState.active_on_calculator
           .inject([]) do |memo, state|
      state_name   = state.name
      abbreviation = state.abbreviation
      # memo << ["#{abbreviation} - #{state_name.titleize}", state_name, { 'data-tax-label' => state.tax_jurisdiction_type.name }] #create the drop down collection
      memo << { label: "#{abbreviation} - #{state_name.titleize}", value: state_name, tax_label: state.tax_jurisdiction_type.name } # create the drop down collection
    end.sort { |a, b| a[1] <=> b[1] } # sort alphabetically for good measure and freeze for safe keeping
  end
end
