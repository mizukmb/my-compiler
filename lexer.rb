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

      if char =~ space_or_indent
        next_word!
        next
      end

      while @str.size > @index
        ret.push case char
                 when number_pattern
                   w = char
                   next_word!
                   while char =~ number_pattern
                     w += char
                     next_word!
                   end
                   ['lit', w.to_i]
                 when string_pattern
                   next_word!
                   w = ''

                   until char =~ string_pattern
                     w += char
                     next_word!
                   end

                   next_word!

                   ['lit', w]
                 when word_pattern
                   w = char
                   next_word!
                   while char =~ word_pattern
                     w += char
                     next_word!
                   end 

                   if reserved_words =~ w
                     ["reserved_statement_#{w}", w]
                   else
                     raise MyLexerError
                   end
                 when symbol_pattern
                   w = char
                   next_word!

                   [symbol_name(w), w]
                 when operator_pattern
                   w = char
                   next_word!
                   while char =~ operator_pattern
                     w += char
                     next_word!
                   end
                   [operator_name(w), w]
                 when newline
                   next_word!

                   ['newline', '\n']
                 else
                   raise MyLexerError
                 end

        while char =~ space_or_indent
          next_word!
        end
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

  def string_pattern
    %r('|")
  end

  def operator_pattern
    %r(\+|-|\*|\/|%|>|>|=|<|<|!)
  end

  def word_pattern
    %r(\A[a-z]+\Z)
  end

  def symbol_pattern
    %r(\(|\)|\{|\})
  end

  # 半角・全角スペース、タブ
  def space_or_indent
    %r( |　|\t)
  end

  def newline
    %r(\n)
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
    when '>'
      'gt'
    when '>='
      'ge'
    when '=='
      'eq'
    when '<'
      'lt'
    when '<='
      'le'
    when '!='
      'ne'
    else
      nil
    end
  end

  def symbol_name(word)
    'symbol_' + case word
    when '('
      'left_parenthesis'
    when ')'
      'right_parenthesis'
    when '{'
      'left_curly_brace'
    when '}'
      'right_curly_brace'
    end
  end
end
