module ExceptionNotifier
  class CustomSlackNotifier < BaseNotifier
    include ExceptionNotifier::BacktraceCleaner

    attr_accessor :notifier

    def initialize(options)
      super
      begin
        @ignore_data_if = options[:ignore_data_if]
        @backtrace_lines = options[:backtrace_lines]

        webhook_url = options.fetch(:webhook_url)
        @message_opts = options.fetch(:additional_parameters, {})
        @color = @message_opts.delete(:color) { 'danger' }
        @notifier = Slack::Notifier.new webhook_url, options
      rescue
        @notifier = nil
      end
    end

    def call(exception, options={})
      errors_count = options[:accumulated_errors_count].to_i
      measure_word = errors_count > 1 ? errors_count : (exception.class.to_s =~ /^[aeiou]/i ? 'An' : 'A')
      exception_name = "*#{measure_word}* `#{exception.class.to_s}`"
      pretext = ''

      #################################
      # BUILDS MAIN TEXT MESSAGE HERE #
      #################################

      if options[:env].nil?
        data = options[:data] || {}
        text = "#{exception_name} *occured in background*\n"
      else
        env = options[:env]
        data = (env['exception_notifier.exception_data'] || {}).merge(options[:data] || {})

        kontroller = env['action_controller.instance']
        request = "#{env['REQUEST_METHOD']} <#{env['REQUEST_URI']}>"
        text = "#{exception_name} *occurred while* `#{request}`"
        text += " *was processed by* `#{kontroller.controller_name}##{kontroller.action_name}`" if kontroller
        text += "\n"
      end

      #################################
      # BUILDS PRETEXT HERE           #
      #################################

      pretext = "#{ENV.fetch('HEROKU_APP_NAME', 'Speed Leasing Local').titleize} Exception"

      #################################################
      # BIULD FIELDS ARRAY OF TITLE/VALUE HASHES HERE #
      #################################################

      clean_message = exception.message.gsub("`", "'")
      fields = [ { title: 'Exception', value: clean_message } ]

      fields.push({ title: 'Hostname', value: Socket.gethostname })

      if exception.backtrace
        formatted_backtrace = @backtrace_lines ? "```#{exception.backtrace.first(@backtrace_lines).join("\n")}```" : "```#{exception.backtrace.join("\n")}```"
        fields.push({ title: 'Backtrace', value: formatted_backtrace })
      end

      unless data.empty?
        deep_reject(data, @ignore_data_if) if @ignore_data_if.is_a?(Proc)
        data_string = data.map{|k,v| "#{k}: #{v}"}.join("\n")
        fields.push({ title: 'Data', value: "```#{data_string}```" })
      end

      ##################################
      # BUILD LIST OF ATTACHMENTS HERE #
      ##################################
      # NOTE, THE ORIGINAL SLACK EXCEPTION NOTIFIER PROVIDES NO WAY TO CUSTOMIZE THIS....
      # ...

      attchs = [color: @color, pretext: pretext, text: text, fields: fields, mrkdwn_in: %w(text fields)]

      if valid?
        send_notice(exception, options, clean_message, @message_opts.merge(attachments: attchs)) do |msg, message_opts|
          @notifier.ping '', message_opts
        end
      end
    end

    protected

    def valid?
      !@notifier.nil?
    end

    def deep_reject(hash, block)
      hash.each do |k, v|
        if v.is_a?(Hash)
          deep_reject(v, block)
        end

        if block.call(k, v)
          hash.delete(k)
        end
      end
    end

  end
end
