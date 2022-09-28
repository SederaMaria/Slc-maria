require 'pdf-reader'

class PdftkClient
  attr_reader :source_file

  def initialize(source_file:)
    @source_file = Shellwords.escape source_file
  end
  
  def extract_last(pages:)
    end_page    = doc_length
    start_page  = doc_length.to_i - (pages - 1)
    filepath = "#{Rails.root}/tmp/#{gen_filename}"
    escaped_path = Shellwords.escape filepath

    `pdftk #{source_file} cat #{start_page}-#{end_page} output #{escaped_path}`

    return filepath
  end

  def extract_risk_based_pricing_letter
    length       = doc_length
    start        = length.to_i - 3
    finish       = length.to_i - 1
    filepath     = "#{Rails.root}/tmp/#{gen_filename}"
    escaped_path = Shellwords.escape filepath
    
    reader = PDF::Reader.new(source_file)
    pages = []
    reader.pages.each do |page|
      pages << JSON.parse(page.to_json)["pagenum"].to_i if page.text.include?("Credit Score Disclosure")
      start        = pages.min
      finish       = pages.max
    end
    command = "#{PdftkConfig.executable_path} #{source_file} cat #{start}-#{finish} output #{escaped_path}"
    
    Open3.popen3(command) do |stdin, stdout, stderr|
      stderr.read
    end
    if File.zero?(escaped_path)
      raise "Error generating PDF with #{command}.  doc_length was #{doc_length}."
    end

    return escaped_path
  end

  def doc_length
    command = "#{PdftkConfig.executable_path} #{source_file} dump_data | awk '/NumberOfPages/{print $2}'"
    Open3.popen3(command) do |stdin, stdout, stderr|
      stdout.read.strip.to_i || 0
    end
  end

private
  def gen_filename
    name  = (0...15).map { (65 + rand(26)).chr }.join
    name += '.pdf'
    name
  end
end