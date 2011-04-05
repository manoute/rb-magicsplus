require 'rspec' 
require 'rmagics++'

def narray_installed
  begin
    require 'narray'
    true
  rescue LoadError
    puts "\nnarray not found, narray tests won't be run."
    false
  end
end

RSpec::Matchers.define :be_the_same_ps_file do |file1|
  match do |file|
    output = open(file,"r") {|f| f.readlines} 
    expected = open(file1,"r") {|f| f.readlines} 
    ((output - expected).length <= 1) && ((expected - output).length <= 1) 
  end

  failure_message_for_should do |file|
    "expected file #{file} to be identical to #{file1}"
  end

  failure_message_for_should_not do |file|
    "expected file #{file} to be different from #{file1}"
  end
end
