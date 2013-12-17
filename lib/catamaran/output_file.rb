module Catamaran
  class OutputFile
    attr_accessor :filename

    def initialize( filename = nil ) 
      self.filename = filename     
    end     

    def write( line )
      unless @file_descriptor
        @file_descriptor = File.open( self.filename, "a" )
      end 

      @file_descriptor.puts( line )
      @file_descriptor.flush
    end
  end
end