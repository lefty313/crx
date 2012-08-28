module Crx
  module Options

    class New < Default
      attr_accessor :name, :type
      validates :type, presence: true, inclusion: {in: ['browser_action','page_action'], message: "%{value} is wrong type"}

      def initialize(name, options)
        self.name = name
        self.type = options['type']
      end

      def directories
        ['defaults',"#{type}"]
      end
    end
  end
end