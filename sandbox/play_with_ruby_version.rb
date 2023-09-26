version = RUBY_VERSION.split('.').map { |x| x.to_i }
puts RUBY_VERSION
puts version.class

puts "aktuelle Ruby Version ist kleiner als die gewünschte:",  version <=> [3,2,3]
puts "aktuelle Ruby Version ist gleich der gewünschten:",  version <=> [3,2,2]
puts"aktuelle Ruby Version ist grösser als die gewünschte:",  version <=> [1,8,3]

puts RUBY_VERSION >= "2.0.0"
puts RUBY_VERSION >= "3.2.3"

#_RUBY_VERSION="1.9.1"

puts "Ist Ruby_version 1.9.2"
puts RUBY_VERSION =~ /^(?:1\.9|2\.)/
puts "Ist Ruby_version 3.2.2"
puts RUBY_VERSION =~ /^(?:3\.2|2\.)/