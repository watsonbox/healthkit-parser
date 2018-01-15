require 'spec_helper'

describe Healthkit::Parser::Workout do
  describe '.parse' do
    subject(:workout) { described_class.parse(xml) }

    shared_examples "correctly parsed" do
      it "has correct attributes" do
        expect(workout.workout_activity_type).to eq "HKWorkoutActivityTypeRunning"
        expect(workout.duration).to eq 24.41666666666667
        expect(workout.duration_unit).to eq "min"
        expect(workout.total_distance).to eq 4.422
        expect(workout.total_distance_unit).to eq "km"
        expect(workout.total_energy_burned).to eq 372.7000122070312
        expect(workout.total_energy_burned_unit).to eq "kcal"
        expect(workout.source_name).to eq "Strava"
        expect(workout.source_version).to eq "8846"
        expect(workout.creation_date).to eq Time.parse("2017-09-11 23:52:15 +0200")
        expect(workout.start_date).to eq Time.parse("2017-09-11 20:33:14 +0200")
        expect(workout.end_date).to eq Time.parse("2017-09-11 20:57:52 +0200")
        expect(workout.xml).to eq xml.to_s
      end
    end

    context "from an xml string" do
      let(:xml) { '<Workout workoutActivityType="HKWorkoutActivityTypeRunning" duration="24.41666666666667" durationUnit="min" totalDistance="4.422" totalDistanceUnit="km" totalEnergyBurned="372.7000122070312" totalEnergyBurnedUnit="kcal" sourceName="Strava" sourceVersion="8846" creationDate="2017-09-11 23:52:15 +0200" startDate="2017-09-11 20:33:14 +0200" endDate="2017-09-11 20:57:52 +0200"><MetadataEntry key="HKExternalUUID" value="strava://activities/1179616468"/></Workout>' }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { '<Workout workoutActivityType="HKWorkoutActivityTypeRunning" duration="24.41666666666667" durationUnit="min" totalDistance="4.422" totalDistanceUnit="km" totalEnergyBurned="372.7000122070312" totalEnergyBurnedUnit="kcal" creationDate="2017-09-11 23:52:15 +0200" startDate="2017-09-11 20:33:14 +0200" endDate="2017-09-11 20:57:52 +0200"><MetadataEntry key="HKExternalUUID" value="strava://activities/1179616468"/></Workout>' }

        it "fails" do
          expect { workout }.to raise_exception "Workout missing required attribute(s): source_name"
        end
      end
    end

    context "from an xml node" do
      let(:xml) { Nokogiri::XML.parse('<Workout workoutActivityType="HKWorkoutActivityTypeRunning" duration="24.41666666666667" durationUnit="min" totalDistance="4.422" totalDistanceUnit="km" totalEnergyBurned="372.7000122070312" totalEnergyBurnedUnit="kcal" sourceName="Strava" sourceVersion="8846" creationDate="2017-09-11 23:52:15 +0200" startDate="2017-09-11 20:33:14 +0200" endDate="2017-09-11 20:57:52 +0200"><MetadataEntry key="HKExternalUUID" value="strava://activities/1179616468"/></Workout>').root }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { Nokogiri::XML.parse('<Workout workoutActivityType="HKWorkoutActivityTypeRunning" duration="24.41666666666667" durationUnit="min" totalDistance="4.422" totalDistanceUnit="km" totalEnergyBurned="372.7000122070312" totalEnergyBurnedUnit="kcal" creationDate="2017-09-11 23:52:15 +0200" startDate="2017-09-11 20:33:14 +0200" endDate="2017-09-11 20:57:52 +0200"><MetadataEntry key="HKExternalUUID" value="strava://activities/1179616468"/></Workout>').root }

        it "fails" do
          expect { workout }.to raise_exception "Workout missing required attribute(s): source_name"
        end
      end
    end
  end
end
