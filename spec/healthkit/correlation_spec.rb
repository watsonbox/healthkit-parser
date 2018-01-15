require 'spec_helper'

describe Healthkit::Parser::Correlation do
  describe '.parse' do
    subject(:correlation) { described_class.parse(xml) }

    shared_examples "correctly parsed" do
      it "has correct attributes" do
        expect(correlation.type).to eq "HKCorrelationTypeIdentifierBloodPressure"
        expect(correlation.source_name).to eq "Health"
        expect(correlation.source_version).to eq "10.3.3"
        expect(correlation.creation_date).to eq Time.parse("2017-10-06 10:19:20 +0100")
        expect(correlation.start_date).to eq Time.parse("2014-09-30 10:18:00 +0100")
        expect(correlation.end_date).to eq Time.parse("2014-09-30 10:18:00 +0100")
      end

      it "has the correct records" do
        expect(correlation.records.count).to eq(2)
        expect(correlation.records.first.type).to eq "HKQuantityTypeIdentifierBloodPressureDiastolic"
        expect(correlation.records.last.type).to eq "HKQuantityTypeIdentifierBloodPressureSystolic"
      end
    end

    context "from an xml string" do
      let(:xml) { '<Correlation type="HKCorrelationTypeIdentifierBloodPressure" sourceName="Health" sourceVersion="10.3.3" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100"><MetadataEntry key="HKWasUserEntered" value="1"/><Record type="HKQuantityTypeIdentifierBloodPressureDiastolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="70"><MetadataEntry key="HKWasUserEntered" value="1"/></Record><Record type="HKQuantityTypeIdentifierBloodPressureSystolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="114"><MetadataEntry key="HKWasUserEntered" value="1"/></Record></Correlation>' }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { '<Correlation type="HKCorrelationTypeIdentifierBloodPressure" sourceVersion="10.3.3" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100"><MetadataEntry key="HKWasUserEntered" value="1"/><Record type="HKQuantityTypeIdentifierBloodPressureDiastolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="70"><MetadataEntry key="HKWasUserEntered" value="1"/></Record><Record type="HKQuantityTypeIdentifierBloodPressureSystolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="114"><MetadataEntry key="HKWasUserEntered" value="1"/></Record></Correlation>' }

        it "fails" do
          expect { correlation }.to raise_exception "Correlation missing required attribute(s): source_name"
        end
      end
    end

    context "from an xml node" do
      let(:xml) { Nokogiri::XML.parse('<Correlation type="HKCorrelationTypeIdentifierBloodPressure" sourceName="Health" sourceVersion="10.3.3" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100"><MetadataEntry key="HKWasUserEntered" value="1"/><Record type="HKQuantityTypeIdentifierBloodPressureDiastolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="70"><MetadataEntry key="HKWasUserEntered" value="1"/></Record><Record type="HKQuantityTypeIdentifierBloodPressureSystolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="114"><MetadataEntry key="HKWasUserEntered" value="1"/></Record></Correlation>').root }
      include_examples "correctly parsed"

      context "missing attributes" do
        let(:xml) { Nokogiri::XML.parse('<Correlation type="HKCorrelationTypeIdentifierBloodPressure" sourceVersion="10.3.3" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100"><MetadataEntry key="HKWasUserEntered" value="1"/><Record type="HKQuantityTypeIdentifierBloodPressureDiastolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="70"><MetadataEntry key="HKWasUserEntered" value="1"/></Record><Record type="HKQuantityTypeIdentifierBloodPressureSystolic" sourceName="Health" sourceVersion="10.3.3" unit="mmHg" creationDate="2017-10-06 10:19:20 +0100" startDate="2014-09-30 10:18:00 +0100" endDate="2014-09-30 10:18:00 +0100" value="114"><MetadataEntry key="HKWasUserEntered" value="1"/></Record></Correlation>').root }

        it "fails" do
          expect { correlation }.to raise_exception "Correlation missing required attribute(s): source_name"
        end
      end
    end
  end
end
