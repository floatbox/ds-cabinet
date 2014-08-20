require 'spec_helper'
require 'phone'

describe Phone do
  let(:samples) { Hash.new( 
    #value,                 self.valid?, self.value
    Class =>                [false,       "Class"],
    nil =>                  [false,       ""],
    0 =>                    [false,       "0"],
    1 =>                    [false,       "1"],
    -1 =>                   [false,       "-1"],
    "a" =>                  [false,       "a"],
    "8 495 223 23 23" =>    [false,      "84952232323"],
    "84952232323" =>        [false,      "84952232323"],
    "8(495)2232323" =>      [false,      "84952232323"],
    "8(495)2232323" =>      [false,      "84952232323"],
    "7(495)2232323" =>      [false,      "74952232323"],
    "+7495223-23-23" =>     [true,       "+74952232323"],
    "+7(495)223-2323" =>    [true,       "+74952232323"],
    "+7(495)223-23-23" =>   [true,       "+74952232323"],
    "+7(495)2-2-3-2-323" => [true,       "+74952232323"],
    "+7(495)22 323 23" =>   [true,       "+74952232323"],
    "+7(495)2 2323 23" =>   [true,       "+74952232323"],
    "+7(495)22323 2 3" =>   [true,       "+74952232323"]
                         )
  }

  it "should create" do
    expect { samples.each_pair { |key, val| phone = Phone.new key } }.not_to raise_exception
  end

  it "should sanitize" do
    samples.each_pair do |key, val|
      right_value = val.last
      phone = Phone.new key

      phone.value.should == right_value
    end
  end

  it "should validate" do
    samples.each_pair do |key, val|
      right_value = val.first
      phone = Phone.new key

      phone.valid?.should == right_value
    end
  end
end
