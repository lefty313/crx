module Crx
  module Options
    class Build < Default
      attr_accessor :path, :format, :name, :options, :destination

      validates :destination, presence: true
      validates :format, inclusion: {in: ['crx','zip'],  message: "you can use only [crx,zip]"}

      def initialize(extension_path=nil,options)
        self.path = Pathname.new(extension_path || Dir.pwd).expand_path
        self.options = options
        self.format = options['format']
        self.destination = options['destination']
        self.name = path.basename.to_s
      end

      def target
        path.join(destination)
      end

      def for_builder
        @for_builder ||= if format_is_crx
          builder_defaults.merge(crx_options)
        else
          builder_defaults.merge(zip_options)
        end
      end

      def package
        @package = if format_is_crx
          target.join("#{name}.crx")
        else
          target.join("#{name}.zip")
        end
      end

      private

      def format_is_crx
        true if format == 'crx'
      end

      def crx_options
        {crx_output: target.join("#{name}.crx").to_s}
      end

      def zip_options
        {zip_output: target.join("#{name}.zip").to_s}
      end

      def builder_defaults
        defaults = {
          ex_dir: path.join(Crx.config.compile_path).to_s,
          pkey_output: target.join("#{name}.pem").to_s,
          verbose: false,
          ignorefile: /\.swp/,
          ignoredir: /\.(?:svn|git|cvs)/
        }
        defaults[:pkey] = pkey if pkey
        defaults
      end

      def pkey
        Dir.glob("#{target}/*.pem").first
      end

    end
  end
end