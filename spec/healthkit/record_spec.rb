require 'spec_helper'

describe Healthkit::Parser::Record do
  describe '.parse' do
    subject(:record) { described_class.parse(xml) }

    shared_examples "correctly parsed" do
      it "has correct attributes" do
        expect(record.type).to eq "HKQuantityTypeIdentifierStepCount"
        expect(record.source_name).to eq "iPhone"
        expect(record.source_version).to eq "9.3.1"
        expect(record.device).to eq "<<HKDevice: 0x17029bad0>, name:iPhone, manufacturer:Apple, model:iPhone, hardware:iPhone8,4, software:9.3.1>"
        expect(record.unit).to eq "count"
        expect(record.creation_date).to eq Time.parse("2016-04-07 21:04:49 +0200")
        expect(record.start_date).to eq Time.parse("2016-04-07 19:56:55 +0200")
        expect(record.end_date).to eq Time.parse("2016-04-07 20:01:56 +0200")
        expect(record.value).to eq "154"
      end
    end

    context "from an xml string" do
      let(:xml) { '<Record type="HKQuantityTypeIdentifierStepCount" sourceName="iPhone" sourceVersion="9.3.1" device="&lt;&lt;HKDevice: 0x17029bad0&gt;, name:iPhone, manufacturer:Apple, model:iPhone, hardware:iPhone8,4, software:9.3.1&gt;" unit="count" creationDate="2016-04-07 21:04:49 +0200" startDate="2016-04-07 19:56:55 +0200" endDate="2016-04-07 20:01:56 +0200" value="154"/>' }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { '<Record type="HKQuantityTypeIdentifierStepCount" sourceVersion="9.3.1" unit="count" creationDate="2016-04-07 21:04:49 +0200" startDate="2016-04-07 19:56:55 +0200" endDate="2016-04-07 20:01:56 +0200"/>' }

        it "fails" do
          expect { record }.to raise_exception "Record missing required attribute(s): source_name"
        end
      end
    end

    context "from an xml node" do
      let(:xml) { Nokogiri::XML.parse('<Record type="HKQuantityTypeIdentifierStepCount" sourceName="iPhone" sourceVersion="9.3.1" device="&lt;&lt;HKDevice: 0x17029bad0&gt;, name:iPhone, manufacturer:Apple, model:iPhone, hardware:iPhone8,4, software:9.3.1&gt;" unit="count" creationDate="2016-04-07 21:04:49 +0200" startDate="2016-04-07 19:56:55 +0200" endDate="2016-04-07 20:01:56 +0200" value="154"/>').root }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { Nokogiri::XML.parse('<Record type="HKQuantityTypeIdentifierStepCount" sourceVersion="9.3.1" unit="count" creationDate="2016-04-07 21:04:49 +0200" startDate="2016-04-07 19:56:55 +0200" endDate="2016-04-07 20:01:56 +0200"/>').root }

        it "fails" do
          expect { record }.to raise_exception "Record missing required attribute(s): source_name"
        end
      end
    end
  end
end
