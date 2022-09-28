class LeasePackageTemplateUploader < CarrierWave::Uploader::Base
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{LeasePackageTemplate.model_name.singular}/#{mounted_as}/#{model.id}"
  end

  def accessible_path_or_uri
    # In a Heroku environment, return the Amazon S3 URL where the file is stored.
    # If Test environment, return the file system path.
    # If Development, return the public directory path.
    return self.current_path if Rails.env.development?
    Rails.env.test? ? self.current_path : self.to_s
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(pdf)
  end

end
