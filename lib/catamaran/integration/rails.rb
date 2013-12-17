##
# Ties Rails to Catamaran

module Catamaran
  module Integration
    module Rails3
      if defined?( Rails::Railtie )
        class Railtie < Rails::Railtie
          initializer :load_base_catamaran do
            initializer = Rails.root.join( "config", "initializers", "catamaran.rb" )
            require initializer if File.exist?( initializer )

            Catamaran::Manager.add_output_file(  Catamaran::OutputFile.new( Rails.root.join( "log", "#{Rails.env}.log" ) ) )
          end

          initializer :load_environment_specific_catamaran do
            initializer = Rails.root.join( "config", "initializers", "catamaran", "#{Rails.env}.rb" )
            require initializer if File.exist?( initializer )
          end
        end
      end
    end
  end
end
