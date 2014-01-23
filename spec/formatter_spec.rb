require "spec_helper"

describe Catamaran::Formatter do
  before(:each){ Catamaran::Formatter.caller_enabled = false }

  context "when using the default format" do
    let(:severity){ 7000 }
    let(:path){ '/douglas/adams' }
    let(:log_message){ "Don't Panic" }

    context "with no options" do
      it "outputs the default format" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
        message.should match /^\s+ERROR\s/
        # message.should match /pid\-\d+\s\[/
        # message.should match /\s\[.*\]/
        # message.should match /#{path}/
        # message.should match /#{log_message}$/
      end
    end

    context "with caller detail specified" do
      let(:opts){ {:file => "adams", :line => 42, :class => "Ford::Prefect", :method => "make_tea"} }

      it "outputs the default format with extra information" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{log_message}/
        message.should match /\s\(#{opts[:file]}/
        message.should match /:#{opts[:line]}/
        message.should match /:in \`#{opts[:class]}\./
        message.should match /#{opts[:method]}\'/
        message.should match /\)$/
      end
    end

    context "without caller detail specified, but caller information enabled" do
      it "outputs the default format with derived caller information" do
        Catamaran::Formatter.caller_enabled = true
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, {} )
        message.should match /#{log_message}\s\(.*\)/
      end
    end

    context "with the backtrace option specified" do
      let(:opts){ {:backtrace => true } }

      it "outputs the default format with a backtrace" do
        message = Catamaran::Formatter.construct_formatted_message( severity, path, log_message, opts)
        message.should match /#{log_message}\sfrom:\n.+/
      end
    end
  end
end
