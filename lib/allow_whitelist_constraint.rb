class AllowWhitelistConstraint
  def initialize
    if Rails.env.staging? || Rails.env.production?
      set_whitelist
    end
  end

  def set_whitelist
    @whitelist = [
        'http://speedleasing.com.s3-website-us-east-1.amazonaws.com/',
        'https://www.speedleasing.com/',
        'https://speedleasing.com/',
        'future.speedleasing.com'].freeze
  end

  def matches?(request)
    if Rails.env.staging? || Rails.env.production?
      @whitelist.include?(request.url)
    else
      true
    end
  end
end
