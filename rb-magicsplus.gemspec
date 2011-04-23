# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rb-magicsplus}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mathieu Deslandes"]
  s.date = %q{2011-04-23}
  s.description = %q{Ruby wrapper for magics++}
  s.email = %q{math.deslandes @nospam@ gmail.com}
  s.extensions = ["ext/rmagics_raw/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "README.md", "ext/rmagics_raw/extconf.rb", "ext/rmagics_raw/rmagics_raw_c_writer.rb", "lib/rmagics++.rb", "lib/rmagics++/core_ext/array.rb", "lib/rmagics++/core_ext/float.rb", "lib/rmagics++/core_ext/integer.rb", "lib/rmagics++/core_ext/narray.rb", "lib/rmagics++/core_ext/string.rb", "lib/rmagics++/rmagics++.rb"]
  s.files = ["CHANGELOG", "README.md", "ext/rmagics_raw/extconf.rb", "ext/rmagics_raw/rmagics_raw_c_writer.rb", "lib/rmagics++.rb", "lib/rmagics++/core_ext/array.rb", "lib/rmagics++/core_ext/float.rb", "lib/rmagics++/core_ext/integer.rb", "lib/rmagics++/core_ext/narray.rb", "lib/rmagics++/core_ext/string.rb", "lib/rmagics++/rmagics++.rb", "rb-magicsplus.gemspec"]
  s.homepage = %q{https://github.com/manoute/rb-magicsplus}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rb-magicsplus", "--main", "README.md"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{rb-magicsplus}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Ruby wrapper for magics++}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
