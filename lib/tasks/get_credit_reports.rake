namespace :lease_application_attachment do
  desc 'Download attachments from S3'
  task :download do |t, args|
    require 'open-uri'
    dates_array = [['2019-01-18', '2019-01-31'],['2019-02-01', '2019-02-28'],['2019-03-01', '2019-03-31'],['2019-04-01', '2019-04-30'],['2019-05-01', '2019-05-31'],['2019-06-01', '2019-06-30'],['2019-07-01', '2019-07-31'],['2019-08-01', '2019-08-31'], ['2019-09-01', '2019-09-11']]
    dates_array.each do |dates|
      start_date = dates[0].to_date
      end_date = dates[1].to_date
      las = CreditReport.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
      #bucket_name = ENV.fetch('BUCKETEER_BUCKET_NAME')
      urls = []
      las.each do |la|
        url = la.upload.url
        #url = "https://bucketeer-1733dd6b-7044-4d23-a7f9-b8480bccf066.s3.amazonaws.com/uploads/lease_application_attachments/45/busbr5ver0ewewpjdaxr.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIG3Y5HMKG3GQLISA%2F20190806%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190806T170359Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=709b731aee76a6fc290e7d85f4d27e54267ea3bdc79477c377d216ca1275479c"
        urls << url
      end
      puts urls
      AdminMailer.test_mailer(urls, dates[0], dates[1]).deliver_now
    end
  end  
end
