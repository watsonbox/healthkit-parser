module Healthkit
  module Parser
    class Record
      ATTRIBUTES = :type, :source_name, :source_version, :device, :unit, :creation_date, :start_date, :end_date, :value
      REQUIRED_ATTRIBUTES = :type, :source_name, :start_date, :end_date

      attr_accessor *ATTRIBUTES

      def self.parse(xml_string_or_node)
        node = case xml_string_or_node
          when Nokogiri::XML::Element then xml_string_or_node
          else Nokogiri::XML.parse(xml_string_or_node.to_s).root
        end

        new.tap do |record|
          missing_attributes = REQUIRED_ATTRIBUTES - REQUIRED_ATTRIBUTES.select do |attribute|
            node[attribute.to_s.camelize(:lower)].present?
          end.compact

          unless missing_attributes.empty?
            raise "Record missing required attribute(s): #{missing_attributes.join(", ")}"
          end

          record.type = node[:type]
          record.source_name = node[:sourceName]
          record.source_version = node[:sourceVersion]
          record.device = node[:device]
          record.unit = node[:unit]
          record.creation_date = Time.parse(node[:creationDate])
          record.start_date = Time.parse(node[:startDate])
          record.end_date = Time.parse(node[:endDate])
          record.value = node[:value]
        end
      end
    end
  end
end
