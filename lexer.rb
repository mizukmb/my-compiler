require 'yaml'

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
          word += char
          next_word!
        else
          break
        end
      end

      ret.push case word
      when reserved_words
        ['reserved_word', word]
      when number_pattern
        ['lit', word]
      when operator_pattern
        [operator_name(word), word]
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

  def reserved_words
    rws = YAML.load_file(File.expand_path('../config/reserved_words.yml', __FILE__))

    Regexp.new(rws.join('|'))
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

  def operator_name(word)
    'operator_' + case word
    when '+'
      'plus'
    when '-'
      'minus'
    when '*'
      'multi'
    when '/'
      'divide'
    when '%'
      'surplus'
    else nil
    end
  end
end
