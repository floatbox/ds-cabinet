module Uas
  # Base class for UAS objects.
  # It contains logic for resource hydration.
  class Base

    # Adds UAS attributes.
    # Each attribute will be added to attributes list as camelized string.
    # Attribute accessor will be added for each attribute.
    # @param args [Array[Symbol]] list of UAS attributes
    def self.uas_attr(*args)
      opts = args.extract_options!
      args.each do |attribute|
        uas_attributes[attribute.to_s.camelize] = {}
        attr_accessor attribute
      end
    end

    # Creates new instance by JSON.
    # @param item [Hash] parsed JSON that describes the resource
    # @return [self] new instance of the class with assigned attributes
    def self.hydrate_resource(item)
      resource = self.new

      uas_attributes.each do |attribute, params|
        unless item[attribute].nil?
          resource.send("#{attribute.underscore}=", item[attribute])
        end
      end

      resource
    end

    private

      # @return [Hash] UAS attributes or empty Hash
      def self.uas_attributes
        @uas_attributes ||= {}
      end

  end
end