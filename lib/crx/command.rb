module Crx
  class Command

    def add(name)
      klass(name).new
      true
    end

    def pack(arg1,arg2)
      Foo::Bar.new(arg1,arg2)
    end



    def install
    end

    def new
    end

    private

      def klass(name)
        class_name = name.to_s.classify
        namespace = "Crx::"
        (namespace + class_name).constantize
      end

  end
end

