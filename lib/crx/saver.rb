module Crx
  module Saver

    def file
      raise NotImplementedError
    end

    def path
      raise NotImplementedError
    end

    def save
      File.open(path,"w") do |f|
        f.write(file.to_yaml)
      end
    end

  end
end