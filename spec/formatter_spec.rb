require "spec_helper"

describe Catamaran::Formatter do
  before(:each){ Catamaran::Formatter.caller_enabled = false }

  let(:severity){ 7000 }
  let(:path){ '/douglas/adams' }
  let(:log_message){ "Don't panic.  The best #!%%&$* car is now 50% off" }

  context "when using a custom format pattern" do
    context "with no options" do
      let(:pattern) { "%c (%d) %p PID: %P | %m" }
      it "outputs the custom format" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, :pattern => pattern)
        message.should match /^\s+ERROR\s\(.*\)\s#{path}\sPID:\s\d+\s\|\s#{Regexp.escape(log_message)}$/
      end
    end
  end

  context "when a custom format pattern is NOT specified" do
    it "should make use of Manager.formatter_pattern" do
      Catamaran::Manager::formatter_pattern = "%c pid-%P [%d] %p - %m"
      message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
      message.should match /^\s+ERROR\spid\-\d+\s\[.*\]\s#{path}\s\-\s#{Regexp.escape(log_message)}$/

      Catamaran::Manager.reset

      Catamaran::Manager::formatter_pattern = "%-6p pid-%pid [%d{yyyy-MM-dd HH:mm:ss.SSS}] %47C - %m"
      message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
      message.should match /^\s+ERROR\spid\-\d+\s\[.*\]\s\s\s\s\s\s\s\s\s\s\s+#{path}\s\-\s#{Regexp.escape(log_message)}$/
    end
  end

  context "when using the default format" do
    context "with no options" do
      it "outputs the default format of %-6p pid-%pid [%d{yyyy-M-d HH:mm:ss:SSS}] %47C - %m" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
        message.should match /^\s+ERROR\spid\-\d+\s\[.*\]\s+#{path}\s\-\s#{Regexp.escape(log_message)}$/
      end
    end

    context "with caller detail specified" do
      let(:opts){ {:file => "adams", :line => 42, :class => "Ford::Prefect", :method => "make_tea"} }

      it "outputs the default format with extra information" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\s\(#{opts[:file]}:#{opts[:line]}:in \`#{opts[:class]}\.#{opts[:method]}\'\)$/
      end
    end

    context "with incomplete caller detail specified" do
      let(:opts){ {:file => "adams", :line => 42, :class => "Ford::Prefect", :method => "make_tea"} }

      it "no file, outputs the default format without extra information" do
        opts.delete :file
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /^\s+ERROR\spid\-\d+\s\[.*\]\s+#{path}\s\-\s#{Regexp.escape(log_message)}$/
      end

      it "no line number, outputs extra information without the line number" do
        opts.delete :line
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\s\(#{opts[:file]}:in \`#{opts[:class]}\.#{opts[:method]}\'\)$/
      end

      it "no class, outputs extra information without the class" do
        opts.delete :class
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\s\(#{opts[:file]}:#{opts[:line]}:in \`#{opts[:method]}\'\)$/
      end

      it "no method, outputs extra information without the method" do
        opts.delete :method
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\s\(#{opts[:file]}:#{opts[:line]}:in \`#{opts[:class]}\.'\)$/
      end

      it "no class and no method, extra information without the class and method" do
        opts.delete :method
        opts.delete :class
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\s\(#{opts[:file]}:#{opts[:line]}\)$/
      end
    end

    context "without caller detail specified, but caller information enabled" do
      it "outputs the default format with derived caller information" do
        Catamaran::Formatter.caller_enabled = true
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
        message.should match /#{Regexp.escape(log_message)}\s\(.*\)/
      end
    end

    context "with the backtrace option specified" do
      let(:opts){ {:backtrace => true } }

      it "outputs the default format with a backtrace" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{Regexp.escape(log_message)}\sfrom:\n.+/
      end
    end
  end
end
