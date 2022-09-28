class RelatedApplicationSerializer < ApplicationSerializer
  attributes :id, :application_identifier, :credit_status, :document_status, :lessee, :colessee, :expiration_date

  def credit_status
    self.object.credit_status.humanize.titlecase
  end

  def document_status
    self.object.document_status.humanize.titlecase
  end

  def lessee
    self.object.lessee&.name&.upcase
  end

  def colessee
    self.object.colessee&.name&.upcase
  end

  def expiration_date
    self.object.expiration_date
  end
  
end
