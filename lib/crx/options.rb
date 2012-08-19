require 'active_model'
require 'active_model/validations'

module Crx
  module Options
    class FileContainer < Struct.new(:from,:to)
    end

    class ValidationError < Exception
    end

    class Default
      include ActiveModel::Validations

      def validate!
        raise ValidationError.new(errors.full_messages.join(', ')) unless valid?
      end
    end
  end
end