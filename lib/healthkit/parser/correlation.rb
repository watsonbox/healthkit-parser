module Healthkit
  module Parser
    class Correlation
      ATTRIBUTES = :type, :source_name, :source_version, :creation_date, :start_date, :end_date, :xml
      REQUIRED_ATTRIBUTES = :type, :source_name, :start_date, :end_date

      attr_accessor *ATTRIBUTES
      attr_accessor :records

      def self.parse(xml_string_or_node)
        node = case xml_string_or_node
          when Nokogiri::XML::Element then xml_string_or_node
          else Nokogiri::XML.parse(xml_string_or_node.to_s).root
        end

        new.tap do |correlation|
          missing_attributes = REQUIRED_ATTRIBUTES - REQUIRED_ATTRIBUTES.select do |attribute|
            node[attribute.to_s.camelize(:lower)].present?
          end.compact

          unless missing_attributes.empty?
            raise "Correlation missing required attribute(s): #{missing_attributes.join(", ")}"
          end

          correlation.type = node[:type]
          correlation.source_name = node[:sourceName]
          correlation.source_version = node[:sourceVersion]
          correlation.creation_date = Time.parse(node[:creationDate])
          correlation.start_date = Time.parse(node[:startDate])
          correlation.end_date = Time.parse(node[:endDate])
          correlation.records = node.xpath(".//Record").map(&Healthkit::Parser::Record.method(:parse))
          correlation.xml = xml_string_or_node.to_s
        end
      end
    end
  end
end
