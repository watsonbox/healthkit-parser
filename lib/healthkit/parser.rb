require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

require "healthkit/parser/version"
require "healthkit/parser/record"

module Healthkit
  module Parser
    ELEMENT_NAMES = [:record]

    def self.parse(xml, element_names: ELEMENT_NAMES)
      element_names = element_names.map(&:to_s).map(&:camelize)

      Nokogiri::XML::Reader(xml).map do |node|
        if node.node_type == Nokogiri::XML::Reader::TYPE_DOCUMENT_TYPE
          comment = Nokogiri::XML(node.outer_xml).at("//comment()").text.strip

          if comment.start_with?("HealthKit Export Version") && comment != "HealthKit Export Version: 3"
            raise "#{comment} is not supported"
          end
        end

        if element_names.include?(node.name) && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          "Healthkit::Parser::#{node.name.camelize}".constantize.parse(node.outer_xml)
        end
      end.compact
    end
  end
end
