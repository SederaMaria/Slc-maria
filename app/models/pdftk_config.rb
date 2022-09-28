class PdftkConfig
  class Configuration
    attr_writer :executable_path

    def executable_path
      
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.executable_path
    @@executable_path ||= `which pdftk`.chomp
  end
end
