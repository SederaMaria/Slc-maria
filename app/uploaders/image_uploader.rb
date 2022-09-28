class ImageUploader < CarrierWave::Uploader::Base
    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_white_list
      %w(jpg jpeg png svg)
    end
  
    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.model_name.collection}/#{model.id}"
    end
  
    def cache_dir
      "#{Rails.root}/tmp/uploads"
    end
  end
  