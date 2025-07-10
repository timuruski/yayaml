require "spec_helper"

RSpec.describe Yayaml::Handler do
  it "calls on_node for terminal nodes" do
    yaml = <<~YAML
      ---
      abc:
        def: 123
        ghi: 234
        jkl:
          mno: 345
          pqr: 456
    YAML

    matcher = Yayaml::Matcher.new("123")
    allow(matcher).to receive(:on_node).and_call_original
    handler = Yayaml::Handler.new(matcher, filename: "example.yml")

    expect { Psych::Parser.new(handler).parse(yaml) }.to output.to_stdout

    expect(matcher).to have_received(:on_node).with(["abc", "def"], "123", "example.yml", 3)
    expect(matcher).to have_received(:on_node).with(["abc", "ghi"], "234", "example.yml", 4)
    expect(matcher).to have_received(:on_node).with(["abc", "jkl", "mno"], "345", "example.yml", 6)
    expect(matcher).to have_received(:on_node).with(["abc", "jkl", "pqr"], "456", "example.yml", 7)
  end

  it "handles sequences" do
    yaml = <<~YAML
      ---
      abc:
        - 123
        - 234
      xyz:
        - 345
        - 456
    YAML

    matcher = Yayaml::Matcher.new("123")
    allow(matcher).to receive(:on_node).and_call_original
    handler = Yayaml::Handler.new(matcher, filename: "example.yml")

    expect { Psych::Parser.new(handler).parse(yaml) }.to output.to_stdout

    expect(matcher).to have_received(:on_node).with(["abc", 0], "123", "example.yml", 3)
    expect(matcher).to have_received(:on_node).with(["abc", 1], "234", "example.yml", 4)
    expect(matcher).to have_received(:on_node).with(["xyz", 0], "345", "example.yml", 6)
    expect(matcher).to have_received(:on_node).with(["xyz", 1], "456", "example.yml", 7)
  end
end
