CarrierWave.configure do |config|
  config.enable_processing = true

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp/"
  elsif Rails.env.development?
    config.storage = :file
    config.root = "#{Rails.root}/public/"
  else #staging, production
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('BUCKETEER_BUCKET_NAME')
    # config.aws_acl    = 'public-read'

    # Optionally define an asset host for configurations that are fronted by a
    # content host, such as CloudFront.
    # config.asset_host = 'http://example.com'

    # The maximum period for authenticated_urls is only 72 hrs / 3 days.
    config.aws_authenticated_url_expiration = 72.hours.seconds.to_i

    # Set custom options such as cache control to leverage browser caching
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    config.aws_credentials = {
      access_key_id:     ENV.fetch('BUCKETEER_AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('BUCKETEER_AWS_SECRET_ACCESS_KEY'),
      region:            ENV.fetch('BUCKETEER_AWS_REGION') # Required
    }
    # Optional: Signing of download urls, e.g. for serving private content through
    # CloudFront. Be sure you have the `cloudfront-signer` gem installed and
    # configured:
    # config.aws_signer = -> (unsigned_url, options) do
    #   Aws::CF::Signer.sign_url(unsigned_url, options)
    # end
  end
    
end
