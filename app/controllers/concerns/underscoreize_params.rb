module UnderscoreizeParams
    extend ActiveSupport::Concern
  
    def process_action(*args)       
        request.parameters.deep_transform_keys!(&:underscore)
        super
    end
  end