require 'open3' #hack why do i have to include this for heroku to work
class PdfDocument
  include ActiveModel::Validations
  include ActionView::Helpers::NumberHelper

  class << self

    def fields
      raise
    end

    def optimize_pdf(path, optimized_path)
      merge( [ path ], optimized_path) # stupid but it works. Even emailed the author of pdftk about it
    end

    def merge(docs, output_path)
      command = "#{PdftkConfig.executable_path} #{docs.join(' ')} cat output #{output_path}"
      Open3.popen3(command) do |stdin, stdout, stderr|
        stderr.read
      end
      raise "Error generating PDF with #{command}" if File.zero?(output_path)
      output_path
    end

    def unmapped_fields_in_template(template_path)
      pdf_forms.get_fields(template_path).reject { |f| fields[f.name] }
    end

    def pdf_forms
      PdfForms.new(PdftkConfig.executable_path)
    end

    def field(format, *names, &blk)
      self.fields ||= Hash.new
      names.each do |name|
        puts("[PDF DOCUMENT MAPPING WARNING]: \"#{name}\" has been mapped more than once!") if self.fields.has_key?(name)
        self.fields[name] = { block: blk, format: format }
      end
    end

    def dollars(*names, &blk)
      self.field(:dollars, *names, &blk)
    end

    def text(*names, &blk)
      self.field(:text, *names, &blk)
    end

    def signature(*names, &blk)
      self.field(:text, *names, &blk)
    end

    def integer(*names, &blk)
      self.field(:integer, *names, &blk)
    end

    def date(*names, &blk)
      self.field(:date, *names, &blk)
    end

    def checkbox(*names, &blk)
      self.field(:text, *names, &blk)
    end
  end

  def should_flatten?
    true
  end

  def output_path
    'tmp.pdf'
  end

  def form_fields
    form_hash = {}
    fields.each_pair do |key, opts|
      evaluated = instance_exec &opts[:block]
      form_hash[key] = format(evaluated, opts[:format])
    end
    form_hash
  end

  def template_fields
    template_paths.map do |path|
      pdf_forms.get_fields(path)
    end
  end

  def template_field_names
    template_paths.map do |path|
      pdf_forms.get_field_names(path)
    end
  end

  def unmapped_template_fields
    template_paths.inject({}) do |result, path|
      result.merge({ path => (pdf_forms.get_field_names(path) - fields.keys) })
    end
  end

  def template_paths
    []
  end

  def format(val, format)
    case format
    when :text
      val
    when :dollars
      val && number_with_precision(val, precision: 2, delimiter: ",")
    when :integer
      val && number_with_precision(val, precision: 0, delimeter: ",")
    when :date
      val && val.strftime("%m/%d/%Y")
    end
  end

  def pdf_forms
    @pdf_forms ||= self.class.pdf_forms
  end

  def fill(template, output_path)
    pdf_forms.fill_form(template, output_path, form_fields, flatten: should_flatten?)
    output_path
  end

  def merge(docs, output_path)
    self.class.merge(docs, output_path)
  end

  def formatted_timestamp
    Time.zone.now.in_time_zone('Eastern Time (US & Canada)').strftime('%B %-d %Y at %r %Z')
  end
end
