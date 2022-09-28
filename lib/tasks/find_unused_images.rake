task :find_unused_images do
  raise('ack not found!!! install it with your favorite package manager!') if `which ack`.empty?
  images = Dir.glob('app/assets/images/**/*')

  images_to_delete = images.inject([]) do |memo, image|
    #Ignore Directories
    unless File.directory?(image)
      # print "\nChecking #{image}..."
      print "."
      result = `ack -g -i '(app|public)' | ack -x -w '#{File.basename(image)}'`
      memo.push(image) if result.empty?
    end
    memo
  end
  puts "\n\nDelete unused files running the command below:"
  puts "rm #{images_to_delete.join(" ")}"
end