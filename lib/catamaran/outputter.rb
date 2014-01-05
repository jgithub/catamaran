module Catamaran
  class Outputter
    @@stdout = nil
    @@stderr = nil

    def self.write( formatted_msg )
      @@stdout = Manager.stdout? if @@stdout.nil?
      @@stderr = Manager.stderr? if @@stderr.nil?


      if @@stdout
        $stdout.puts( formatted_msg )
      end

      if @@stderr
        $stderr.puts( formatted_msg )
      end 

      _output_files = Manager._output_files
      _output_files.each do |output_file|
        begin
          output_file.write( formatted_msg )
        rescue Exception => e
          $stderr.puts( "Catamaran is unable to write to logfile: #{output_file}" )
        end
      end if _output_files
    end

    def self.reset
      @@stdout = nil
      @@stderr = nil
    end
  end
end