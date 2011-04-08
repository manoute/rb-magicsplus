require 'mkmf'

LIBDIR      = Config::CONFIG['archdir']
INCLUDEDIR  = Config::CONFIG['archdir']

header_dirs = []
  # Search gem narray if gem is installed
  if system("which gem > /dev/null 2>&1") && (`gem list`.include? 'narray')
    header_dirs <<  File.dirname(`gem which narray`)
  end

  ["","/magics","magics++"].each do |dir|
    # Then search /usr/local for people that installed from source
    header_dirs <<  "/usr/local/include#{dir}"

    # Check the ruby install locations
    header_dirs <<  INCLUDEDIR

    # Finally fall back to /usr
    header_dirs <<  "/usr/include#{dir}"
  end

LIB_DIRS = [


  # Then search /usr/local for people that installed from source
  '/usr/local/lib',

  # Check the ruby install locations
  LIBDIR,

  # Finally fall back to /usr
  '/usr/lib',
]

dir_config('rmagics++', header_dirs, LIB_DIRS)

unless find_header('narray.h')
  puts "narray.h not found, building extension without narray support."
end


unless find_header('magics_api.h')
  abort "Can't find headers file magics_api.h..."
end

#$CFLAGS = `pkg-config --cflags magics`
#$LDFLAGS = `pkg-config --libs magics`
$LDFLAGS = `magics-config --libs`
$CPPFLAGS = `magics-config --cxxflags`


create_makefile("rmagics_raw")

