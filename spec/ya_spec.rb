require "spec_helper"

RSpec.describe "exe/ya" do
  it "searches for YAML values for a pattern" do
    expect { system("exe/ya hello spec/fixtures") }
      .to output(<<~EOS).to_stdout_from_any_process
        spec/fixtures/en-US.yml:4 en-US.app.greeting: Hello, world!
      EOS
  end

  it "searches for YAML paths for a pattern" do
    expect { system("exe/ya -p greeting spec/fixtures") }
      .to output(<<~EOS).to_stdout_from_any_process
        spec/fixtures/en-US.yml:4 en-US.app.greeting: Hello, world!
        spec/fixtures/es-ES.yml:4 es-ES.app.greeting: ¡Hola, mundo!
        spec/fixtures/fr-FR.yml:4 fr-FR.app.greeting: Bonjour le monde!
      EOS
  end

  it "can flatten a YAML file to pipe to other commands" do
    expect { system("exe/ya --flatten spec/fixtures/en-US.yml") }
      .to output(<<~EOS).to_stdout_from_any_process
        spec/fixtures/en-US.yml:4 en-US.app.greeting: Hello, world!
        spec/fixtures/en-US.yml:5 en-US.app.farewell: Goodbye, world!
      EOS
  end

  it "raises an error if the file isn't valid YAML" do
    expect { system("exe/ya -p greeting spec/spec_helper.rb") }
      .to output(<<~EOS).to_stderr_from_any_process
        Failed to parse YAML spec/spec_helper.rb:1:0
      EOS
  end
end
