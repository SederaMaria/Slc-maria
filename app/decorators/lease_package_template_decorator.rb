class LeasePackageTemplateDecorator < Draper::Decorator
  decorates :lease_package_template
  delegate_all

  def filename
    object&.lease_package_template&.file&.filename
  end

  def template_url
    object.lease_package_template.url
  end

  def has_template?
    object.lease_package_template.present?
  end

  def no_template?
    !has_template?
  end

  def us_states
    object.us_states&.to_sentence
  end

  def selected_states
    object.us_states
  end
end
