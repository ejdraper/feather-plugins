module DataMapper
  class Base
    class << self
      def property(*args)
        attr_accessor args.first
      end
    
      def belongs_to(*args)
        attr_accessor args.first
      end
    
      def validates_presence_of(*args)
        true
      end
    
      def before_save(*args)
        true
      end
    
      def after_save(*args)
        true
      end
    
      def after_create(*args)
        true
      end
    end
    
  end
end