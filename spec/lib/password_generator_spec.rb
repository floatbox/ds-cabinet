require 'spec_helper'
require 'password_generator'

describe PasswordGenerator do
  let(:samples) { 
    {
      #pattern                           => regexp to check generated password against
      PasswordGenerator::DEFAULT_PATTERN => /\A[a-z0-9]{9}\Z/,
      'h{22}' => /\A[a-f0-9]{22}\Z/,
    }
  }

  it ".generate" do
    samples.each_pair do |pattern, regexp|
      repetitions = 1000
      (0..repetitions).each do
        password = PasswordGenerator.generate(pattern)
        password.should match regexp
      end
    end
  end

  it ".pattern=" do
    samples.each_pair do |pattern, regexp|
      repetitions = 1000
      (0..repetitions).each do
        PasswordGenerator.pattern= pattern
        password = PasswordGenerator.generate
        password.should match regexp
      end
    end
  end

end
