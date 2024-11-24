require "spec_helper"

RSpec.describe Yayaml::Command do
  describe ".build" do
    it "reads configuration from ARGV" do
      subject = described_class.build(%w[hello spec/fixtures])

      expect(subject.case_sensitive).to eq(false)
      expect(subject.match_path).to eq(false)
      expect(subject.search_pattern).to eq("hello")
      expect(subject.paths).to eq(["spec/fixtures/en-US.yml", "spec/fixtures/es-ES.yml", "spec/fixtures/fr-FR.yml"])
    end
  end

  describe "#initialize" do
    it "initializes with default options" do
      subject = described_class.new

      expect(subject.case_sensitive).to eq(false)
      expect(subject.match_path).to eq(false)
      expect(subject.search_pattern).to eq("")
      expect(subject.paths).to eq([])
    end
  end
end
