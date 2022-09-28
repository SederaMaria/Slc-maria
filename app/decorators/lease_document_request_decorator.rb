class LeaseDocumentRequestDecorator < Draper::Decorator
  decorates :lease_document_request
  delegate_all

  def first_monthly_payment_due_on_presenter
    object.delivery_date ? object.delivery_date : "signing"
  end
 
  def second_monthly_payment_day
    ::LeasePackageDocuments::SecondPaymentDate.calculate(object.delivery_date, :second_monthly_payment, :day)
  end

  def second_ach_day
    ::LeasePackageDocuments::SecondPaymentDate.calculate(object.delivery_date, :second_ach_split_pay, :day)
  end

  def recurring_payment_begins_on
    ::LeasePackageDocuments::SecondPaymentDate.calculate(object.delivery_date, :second_monthly_payment)
  end
end
