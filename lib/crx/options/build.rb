module Crx
  module Options
    class Build < Default
      attr_accessor :path, :format, :name, :options, :destination

      validates :destination, presence: true
      validates :format, inclusion: {in: ['crx','zip'],  message: "you can use only [crx,zip]"}

      def initialize(extension_path=nil,options)
        self.path = File.expand_path(extension_path || Dir.pwd)
        self.options = options
        self.format = options['format']
        self.destination = options['destination']
        self.name = Pathname.new(path).basename.to_s if path
      end

      def target
        File.join(path,destination)
      end

      def for_builder
        @for_builder ||= if format_is_crx
          builder_defaults.merge(crx_options)
        else
          builder_defaults.merge(zip_options)
        end
      end

      private

      def format_is_crx
        true if format == 'crx'
      end

      def crx_options
        {crx_output: File.join(target,"#{name}.crx")}
      end

      def zip_options
        {zip_output: File.join(target,"#{name}.zip")}
      end

      def builder_defaults
        {
          ex_dir: path,
          pkey_output: File.join(target,"#{name}.pem"),
          verbose: false,
          ignorefile: /\.swp/,
          ignoredir: /\.(?:svn|git|cvs)/
        }
      end

    end
  end
end