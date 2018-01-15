require 'time'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require "healthkit/parser/version"
require "healthkit/parser/record"
require "healthkit/parser/workout"
require "healthkit/parser/correlation"

module Healthkit
  module Parser
    ELEMENT_NAMES = [:record, :workout]

    def self.parse(xml, element_names: ELEMENT_NAMES, created_after: nil)
      element_names = element_names.map(&:to_s).map(&:camelize)

      Nokogiri::XML::Reader(xml).map do |node|
        if node.node_type == Nokogiri::XML::Reader::TYPE_DOCUMENT_TYPE
          comment = Nokogiri::XML(node.outer_xml).at("//comment()").text.strip

          if comment.start_with?("HealthKit Export Version") && comment != "HealthKit Export Version: 3"
            raise "#{comment} is not supported"
          end
        end

        if node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT && element_names.include?(node.name)
          object = "Healthkit::Parser::#{node.name.camelize}".constantize.parse(node.outer_xml)
          object if created_after.nil? || object.creation_date > created_after
        end
      end.compact
    end
  end
end
