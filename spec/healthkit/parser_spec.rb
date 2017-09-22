require "spec_helper"

describe Healthkit::Parser do
  it "has a version number" do
    expect(Healthkit::Parser::VERSION).not_to be nil
  end

  describe ".parse" do
    let(:xml) { File.read("spec/assets/export.xml") }
    subject { described_class.parse(xml) }

    it "correctly parses an export file" do
      expect(subject.count).to eq 11
      expect(subject.map(&:class).uniq).to eq [
        Healthkit::Parser::Record,
        Healthkit::Parser::Workout
      ]
    end

    context "the export version is not supported" do
      let(:xml) { File.read("spec/assets/export_unsupported_version.xml") }

      it "fails" do
        expect { subject }.to raise_exception "HealthKit Export Version: 4 is not supported"
      end
    end
  end
end
