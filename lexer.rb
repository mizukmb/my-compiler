class MyLexer
  class MyLexerError < StandardError; end

  def initialize(str)
    @str = str
    @index = 0
  end

  def run
    ret = []

    while @str.size > @index
      if char =~ space_or_line
        next_word!
        next
      end

      word = ''

      while @str.size > @index
        unless char =~ space_or_line
          word = char
          next_word!
        else
          break
        end
      end

      ret.push case word
      when number_pattern
        ['lit', word]
      when operator_pattern
        ['operator', word]
      else raise MyLexerError
      end
    end

    ret
  end


  private
  def char
    @str[@index]
  end

  def next_word!
    @index += 1
  end

  def number_pattern
    %r(\d+)
  end

  def operator_pattern
    %r([+-\\*/%])
  end

  # 半角・全角スペース、タブ、改行
  def space_or_line
    %r( |　|\t|\n)
  end
end

str = '1 + 2'
p MyLexer.new(str).run
