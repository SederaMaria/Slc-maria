class IncomeVerificationSerializer < ApplicationSerializer
  attributes :id, :income_verification_name, :other_type, :income_frequency_name, :employer_client,
             :gross_income_cents, :created_at, :created_by, :file, :income_type

  def gross_income_cents
    if object&.gross_income_cents
      ActionController::Base.helpers.number_to_currency(object&.gross_income)
    end
  end

  def created_at
    object&.created_at&.strftime("%b %d, %Y at %l:%M %p %Z")
  end

  def income_verification_name
    object&.income_verification_type&.income_verification_name
  end

  def income_frequency_name
    object&.income_frequency&.income_frequency_name
  end

  def created_by
    object&.created_by_admin&.full_name
  end

  def file
    object&.income_verification_attachments&.all&.map{ |f|
      {
        file_name: f&.lease_application_attachment&.upload&.identifier,
        url: f&.lease_application_attachment&.upload&.url
      }
    }
  end

  def income_type
    object&.income_type.capitalize
  end
end
