module Healthkit
  module Parser
    class Workout
      ATTRIBUTES = :workout_activity_type, :duration, :duration_unit, :total_distance, :total_distance_unit, :total_energy_burned, :total_energy_burned_unit, :source_name, :source_version, :device, :creation_date, :start_date, :end_date
      REQUIRED_ATTRIBUTES = :workout_activity_type, :source_name, :start_date, :end_date

      attr_accessor *ATTRIBUTES

      def self.parse(xml_string_or_node)
        node = case xml_string_or_node
          when Nokogiri::XML::Element then xml_string_or_node
          else Nokogiri::XML.parse(xml_string_or_node.to_s).root
        end

        new.tap do |workout|
          missing_attributes = REQUIRED_ATTRIBUTES - REQUIRED_ATTRIBUTES.select do |attribute|
            node[attribute.to_s.camelize(:lower)].present?
          end.compact

          unless missing_attributes.empty?
            raise "Workout missing required attribute(s): #{missing_attributes.join(", ")}"
          end

          workout.workout_activity_type = node[:workoutActivityType]
          workout.duration = node[:duration].to_f if node[:duration]
          workout.duration_unit = node[:durationUnit]
          workout.total_distance = node[:totalDistance].to_f if node[:totalDistance]
          workout.total_distance_unit = node[:totalDistanceUnit]
          workout.total_energy_burned = node[:totalEnergyBurned].to_f if node[:totalEnergyBurned]
          workout.total_energy_burned_unit = node[:totalEnergyBurnedUnit]
          workout.source_name = node[:sourceName]
          workout.source_version = node[:sourceVersion]
          workout.device = node[:device]
          workout.creation_date = Time.parse(node[:creationDate]) if node[:creationDate]
          workout.start_date = Time.parse(node[:startDate])
          workout.end_date = Time.parse(node[:endDate])
        end
      end
    end
  end
end
