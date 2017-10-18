require './parser.rb'
require './lexer.rb'
require 'minruby'
require 'pp'

p str = 'if(1 ==2){
50 + 60
70 + 80
90 + 100
11 + 900
if( 3 == 4 ) {
50 + 60
}
}'
a = MyLexer.new(str).run
# p minruby_parse(str)  # => ["+", ["lit", 1], ["/", ["lit", 2], ["lit", 3]]]
p MyParser.new(a).run # => ["+", ["lit", 1], ["/", ["lit", 2], ["lit", 3]]]
