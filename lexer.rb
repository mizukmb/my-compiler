class MyLexer
  class MyLexerError < StandardError; end

  attr_reader :str

  def initialize(str)
    @str = str
  end

  def run
    if str.match number_pattern
      ["lit", str]
    else
      raise MyLexerError
    end
  end

  private
  def number_pattern
    %r(\A\d+\Z)
  end
end

str = "100"

p MyLexer.new(str).run
