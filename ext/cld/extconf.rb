require 'mkmf'

have_library('stdc++') or abort

cld2_files = IO.readlines(File.join(File.dirname(__FILE__), 'internal', 'compile_libs.sh')).
  take_while { |line| !line.include?('libcld2.so') }.reverse.
  take_while { |line| !line.include?('g++') }.
  flat_map { |line| line.split(' ') } - %w(\\)

$srcs = cld2_files.map { |name| File.join('internal', name) } + %w(thunk.cc)
$objs = $srcs.map { |name| name.sub(/[.].*$/, ".#{$OBJEXT}") }

create_makefile('cld/cld2')

IO.write('Makefile', <<-EOF, :mode => 'a')
CLEANOBJS := $(CLEANOBJS) #{File.join('internal', "*.#{$OBJEXT}")}
#{IO.readlines('Makefile').find { |line| /^install:/ === line }.chomp} distclean
EOF
