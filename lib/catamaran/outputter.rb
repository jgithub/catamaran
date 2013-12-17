module Catamaran
  class Outputter

    ##
    # Write the log message to the appropriate location.  Currently that could mean stdout, stderr, or output files.

    def self.write( formatted_msg )
      if Manager.stdout?
        $stdout.puts( formatted_msg )
      end

      if Manager.stderr?
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
  end
end