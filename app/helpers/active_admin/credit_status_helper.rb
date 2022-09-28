module ActiveAdmin::CreditStatusHelper
  def credit_status_options
    LeaseApplication.aasm(:credit_status).states_for_select.to_h
  end

  def document_status_options
    LeaseApplication.aasm(:document_status).states_for_select.to_h
  end

  def get_display_value_from_options(option_array, selected_value)
    option_array.collect{|a| [a[1],a[0]] }.to_h[selected_value]
  end
  
  def welcome_call_status_options
    WelcomeCallStatus.first(2).map{ |s| [s.description, s.id] }.to_h
  end
  
  def welcome_call_type_options
    WelcomeCallType.where(active: true).order('sort_index asc').map{ |s| [s.description, s.id] }.to_h
  end
  
  def welcome_call_result_options
    WelcomeCallResult.where(active: true).order('sort_index asc').map{ |s| [s.description, s.id] }.to_h
  end
  
  def mail_carrier_options
    MailCarrier.where(active: true).order(:id).map{ |s| [s.description, s.id] }.to_h
  end

end
