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

    context "with created_after filter" do
      subject { described_class.parse(xml, created_after: Time.parse("2017-09-11 20:34:27 +0200")) }

      it "only includes entries created after specified time" do
        expect(subject.count).to eq 5
      end
    end
  end
end
