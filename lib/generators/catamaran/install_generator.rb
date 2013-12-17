module Catamaran  
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Generates a custom Catamaran initializer file."

      def self.source_root
        @_rails_config_source_root ||= File.expand_path("../templates", __FILE__
)
      end

      def copy_initializer
        template "catamaran.rb", "config/initializers/catamaran.rb"
      end

      def copy_settings
        directory "catamaran", "config/initializers/catamaran" 
      end

    end
  end
end
