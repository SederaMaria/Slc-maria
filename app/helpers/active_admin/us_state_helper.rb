module ActiveAdmin::UsStateHelper
  def all_states_for_select
    TaxJurisdiction.us_states.map do |k,v|
      ["#{k.titleize}", k]
    end.sort
  end
  def all_us_state
    UsState.all.map do |k,v|
      ["#{k.name}", k]
    end.sort
  end
end