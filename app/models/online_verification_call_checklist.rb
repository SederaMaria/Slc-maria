# == Schema Information
#
# Table name: online_verification_call_checklists
#
#  id                                       :bigint(8)        not null, primary key
#  lease_application_id                     :bigint(8)
#  lessee_available_to_speak                :boolean
#  lessee_social_security_confirm           :boolean
#  lessee_date_of_birth_confirm             :boolean
#  lessee_street_address_confirm            :boolean
#  lessee_email                             :string
#  lessee_best_phone_number                 :string
#  lessee_can_receive_text_messages         :boolean
#  lease_term_confirm                       :boolean
#  monthly_payment_confirm                  :boolean
#  payment_frequency_confirm                :boolean
#  payment_frequency_type                   :integer
#  first_payment_date_confirm               :boolean
#  second_payment_date_confirm              :boolean
#  due_dates_match_lessee_pay_date          :boolean
#  lessee_reported_year                     :integer
#  lessee_reported_make                     :string
#  lessee_reported_model                    :string
#  lessee_has_test_driven_bike              :boolean
#  notes                                    :string
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  completed_by_id                          :bigint(8)
#  vehicle_mileage                          :integer
#  vin_number_last_six                      :string
#  vehicle_color                            :string
#  bike_in_working_order                    :boolean
#  lessee_confirm_residual_value            :boolean
#  lessee_available_to_speak_string         :string
#  lessee_social_security_confirm_comment   :string
#  lessee_date_of_birth_confirm_comment     :string
#  lessee_street_address_confirm_comment    :string
#  lessee_can_receive_text_messages_comment :string
#  lease_term_confirm_comment               :string
#  monthly_payment_confirm_comment          :string
#  payment_frequency_confirm_comment        :string
#  first_payment_date_confirm_comment       :string
#  second_payment_date_confirm_comment      :string
#  due_dates_match_lessee_pay_date_comment  :string
#  lessee_has_test_driven_bike_comment      :string
#  bike_in_working_order_comment            :string
#  issue                                    :boolean          default(FALSE)
#
# Indexes
#
#  index_online_verification_call_checklists_on_completed_by_id  (completed_by_id)
#  index_ovc_checklists_on_lease_application                     (lease_application_id)
#
class OnlineVerificationCallChecklist < ApplicationRecord
  TEMPLATE_PATH = "#{Rails.root}/app/assets/data/online_verification_call_checklist/template.pdf"
  LEASE_APPLICATION_ATTACHMENT_DESC = "Verification Call script PDF"

  belongs_to :lease_application
  belongs_to :completed_by, class_name: 'AdminUser'

  # payment_frequency_type
  # 1 -> Semi-Monthly Payments
  # 2 -> Monthly Payments

  def generate_file!
    create_filled_pdf
  end

  def purge_file!
    File.delete(pdf_filepath) if File.exist?(pdf_filepath)
  end

  def s3_upload!
    s3_bucket.object("#{s3_source_folder}/#{s3_upload_key_format}").upload_file(pdf_filepath)
  end

  def append_to_lease_application_attachments!
    process_lease_application_attachments
  end

  def public_url
    return "#{ENV['ADMIN_PORTAL_BASE_URL']}/online_verification_call_checklist/#{id}/#{pdf_filename_format}?ts=#{DateTime.now.to_i}"
  end

  def remote_url
    object = s3_bucket.object("#{s3_source_folder}/#{s3_upload_key_format}")
    object.presigned_url(:get)
  end

  private

  def pdf_directory
    File.join(Rails.root, "public", "online_verification_call_checklist", "#{id}")
  end

  def pdf_filename_format
    "online-verification-checklist-#{id}.pdf"
  end

  def pdf_filepath
    File.join(pdf_directory, pdf_filename_format)
  end

  def s3_upload_key_format
    "#{id}/#{pdf_filename_format}"
  end

  def s3_bucket
    @s3 ||= Aws::S3::Resource.new(
      region: ENV['OVC_CHECKLIST_S3_REGION'],
      credentials: Aws::Credentials.new(ENV['OVC_CHECKLIST_S3_ACCESS_KEY_ID'], ENV['OVC_CHECKLIST_S3_SECRET_ACCESS_KEY_ID'])
    )
    @bucket ||= @s3.bucket(ENV['OVC_CHECKLIST_S3_BUCKET'])
  end

  def s3_source_folder
    ENV['OVC_CHECKLIST_S3_FOLDER']
  end

  def create_filled_pdf
    FileUtils.rm_rf(pdf_directory) if Dir.exist?(pdf_directory)
    FileUtils::mkdir_p(pdf_directory)

    pdftk.fill_form TEMPLATE_PATH, pdf_filepath, fields, flatten: true
  end

  def pdftk
    @pdftk ||= PdfForms.new(pdftk_path)
  end

  def pdftk_path
    PdftkConfig.executable_path
  end

  def fields
    {
      "header_created_at"                        => created_at&.strftime("%B %d, %Y"),
      "header_dealership"                        => lease_application&.dealership&.name,
      "header_lessee"                            => lease_application&.lessee&.full_name,
      "header_application_id"                    => lease_application&.application_identifier,
      "vs_lessee"                                => lease_application&.lessee&.full_name,
      "vs_dealership"                            => lease_application&.dealership&.name,
      "lessee_available_to_speak"                => boolean_radio_adapter(lessee_available_to_speak),
      "lessee_available_to_speak_comment"        => lessee_available_to_speak_comment,
      "vs_ssn_iv"                                => lease_application&.lessee&.ssn&.chars&.last(4)&.join,
      "lessee_social_security_confirm"           => boolean_radio_adapter(lessee_social_security_confirm),
      "lessee_social_security_confirm_comment"   => lessee_social_security_confirm_comment,
      "vs_lessee_date_of_birth"                  => lease_application&.lessee&.date_of_birth&.strftime("%B %d, %Y"),
      "lessee_date_of_birth_confirm"             => boolean_radio_adapter(lessee_date_of_birth_confirm),
      "lessee_date_of_birth_confirm_comment"     => lessee_date_of_birth_confirm_comment,
      "vs_lessee_address"                        => formatted_lessee_address,
      "lessee_street_address_confirm"            => boolean_radio_adapter(lessee_street_address_confirm),
      "lessee_street_address_confirm_comment"    => lessee_street_address_confirm_comment,
      "lessee_email"                             => lessee_email,
      "lessee_best_phone_number"                 => lessee_best_phone_number,
      "lessee_can_receive_text_messages"         => boolean_radio_adapter(lessee_can_receive_text_messages),
      "lessee_can_receive_text_messages_comment" => lessee_can_receive_text_messages_comment,
      "vs_payment_term"                          => lease_application&.lease_calculator&.term,
      "lease_term_confirm"                       => boolean_radio_adapter(lease_term_confirm),
      "lease_term_confirm_comment"               => lease_term_confirm_comment,
      "vs_payment_amount"                        => payment[:payment],
      "monthly_payment_confirm"                  => boolean_radio_adapter(monthly_payment_confirm),
      "monthly_payment_confirm_comment"          => monthly_payment_confirm_comment,
      "vs_payment_frequency"                     => payment[:payment_monthly_payment_label],
      "payment_frequency_confirm"                => boolean_radio_adapter(payment_frequency_confirm),
      "payment_frequency_confirm_comment"        => payment_frequency_confirm_comment,
      "vs_first_payment_date"                    => payment[:first_payment_date] || "N/A",
      "first_payment_date_confirm"               => boolean_radio_adapter(first_payment_date_confirm),
      "first_payment_date_confirm_comment"       => first_payment_date_confirm_comment,
      "vs_second_payment_date"                   => payment[:second_payment_date] || "N/A",
      "second_payment_date_confirm"              => boolean_radio_adapter(second_payment_date_confirm),
      "second_payment_date_confirm_comment"      => second_payment_date_confirm_comment,
      "due_dates_match_lessee_pay_date"          => boolean_radio_adapter(due_dates_match_lessee_pay_date),
      "due_dates_match_lessee_pay_date_comment"  => due_dates_match_lessee_pay_date_comment,
      "vs_customer_purchase_option"              => lease_application&.lease_calculator&.customer_purchase_option&.format || "N/A",
      "lessee_confirm_residual_value"            => boolean_radio_adapter(lessee_confirm_residual_value),
      "lessee_confirm_residual_value_comment"    => lessee_confirm_residual_value_comment,
      "lessee_reported_year"                     => lessee_reported_year,
      "lessee_reported_make"                     => lessee_reported_make,
      "lessee_reported_model"                    => lessee_reported_model,
      "vehicle_color"                            => vehicle_color,
      "vin_number_last_six"                      => vin_number_last_six,
      "vehicle_mileage"                          => vehicle_mileage,
      "lessee_has_test_driven_bike"              => boolean_radio_adapter(lessee_has_test_driven_bike),
      "lessee_has_test_driven_bike_comment"      => lessee_has_test_driven_bike_comment,
      "bike_in_working_order"                    => boolean_radio_adapter(bike_in_working_order),
      "bike_in_working_order_comment"            => bike_in_working_order_comment,
      "notes"                                    => notes,
      "tr_updated_at"                            => updated_at&.strftime("%B %d, %Y"),
      "tr_completed_by"                          => completed_by&.full_name,
    }
  end

  def boolean_radio_adapter(value)
    return nil if value.nil?
    value ? 'yes' : 'no'
  end

  def formatted_lessee_address
    if address = lease_application&.lessee&.home_address
      [address.street1, address.street2, address.new_city_value, address.state, address.zipcode].reject(&:blank?).compact.join(', ')
    end
  end

  def payment
    @payment ||= get_payment_details
  end

  def get_payment_details
    frequency = lease_application&.payment_frequency
    tm_payment = lease_application&.lease_calculator&.total_monthly_payment
    
    case frequency
    when "split"
      label = 'Twice per Month'
      payment_amount = (tm_payment * 0.5).round(2)
      second_payment_date = lease_application&.second_payment_date&.strftime("%B %d, %Y")
    when "full"
      label = 'Monthly'
      payment_amount = tm_payment

      if lease_application&.first_payment_date
        second_payment_date = (lease_application&.first_payment_date + 1.month).strftime("%B %d, %Y")
      else
        second_payment_date = nil
      end
    else
      label = 'One Time'
      payment_amount = tm_payment
      second_payment_date = nil
    end

    return {
      payment: ActionController::Base.helpers.number_to_currency(payment_amount),
      payment_monthly_payment_label: label&.downcase,
      first_payment_date: lease_application&.first_payment_date&.strftime("%B %d, %Y"),
      second_payment_date: second_payment_date
    }
  end

  def process_lease_application_attachments
    attachment = lease_application.lease_application_attachments.where(description: LEASE_APPLICATION_ATTACHMENT_DESC).first_or_initialize
    attachment.upload = File.open(pdf_filepath)
    attachment.save
  end
end
