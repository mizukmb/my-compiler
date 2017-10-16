require './lexer.rb'

class MyParser
  class MyParserError < StandardError; end

  def initialize(tokenized_list)
    @tokenized_list = tokenized_list
    @index = 0
  end

  def run
    expr
  end

  private
  def token
    @tokenized_list[@index]
  end

  def get_next_token
    @tokenized_list[@index + 1]
  end

  def next_token!
    @index += 1
  end

  def expr
    ret = term

    while !get_next_token.nil? and
          get_next_token[1] =~ plus_or_minus
      next_token!
      ret = [token[1], ret]
      next_token!
      ret.push term
    end

    ret
  end

  def term
    ret = factor

    while !get_next_token.nil? and
          get_next_token[1] =~ multi_or_divide
      next_token!
      ret = [token[1], ret]
      next_token!
      ret.push factor
    end

    ret
  end

  def factor
    if token[1] =~ number
      token
    elsif !get_next_token.nil? and (
          get_next_token[1] =~ plus_or_minus or
          get_next_token[1] =~ multi_or_divide )
      expr
    else
      raise MyParserError
    end
  end

  def number
    %r(\d+)
  end

  def plus_or_minus
    %r([+-])
  end

  def multi_or_divide
    %r([\*/%])
  end
end

str = gets.chomp
a = MyLexer.new(str).run

p MyParser.new(a).run
