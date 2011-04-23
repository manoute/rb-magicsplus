begin
  require 'rake/extensiontask'

  Rake::ExtensionTask.new('rmagics_raw') 

rescue LoadError => e
  p "#{e.message}"
end




