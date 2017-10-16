require './parser.rb'
require './lexer.rb'
require 'minruby'

str = '1 + 2 / 3'
a = MyLexer.new(str).run
p minruby_parse(str)  # => ["+", ["lit", 1], ["/", ["lit", 2], ["lit", 3]]]
p MyParser.new(a).run # => ["+", ["lit", 1], ["/", ["lit", 2], ["lit", 3]]]
