namespace :aws do
  desc 'Synchronize lease_package_template Files between S3 and local'
  task sync_lease_package_templates: :environment do
    #hard coded for now - works with AWS-CLI authenticated and ran from Rails root directory
    raise unless ENV.has_key?('S3_BUCKET_NAME')
    sh "aws s3 sync s3://#{ENV['S3_BUCKET_NAME']}/uploads/#{LeasePackageTemplate.model_name.singular} ./public/uploads/#{LeasePackageTemplate.model_name.singular}/"
  end
end
