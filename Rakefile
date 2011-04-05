Dir.glob('./tasks/*.rb').each { |t| require t }

require 'rake/extensiontask'
require './ext/rmagics_raw/rmagics_raw_c_writer.rb'

Rake::ExtensionTask.new('rmagics_raw') 


