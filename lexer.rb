class MyLexer
  class MyLexerError < StandardError; end

  def initialize(str)
    @str = str
    @index = 0
    @ret = []
  end

  def run
    @str.each_char do |char|
      break if char == "\n"

      if char =~ space_or_line
        next_word!
        next
      end

      # 数値リテラルチェック
      break unless @ret.empty?
      @str[@index..-1].each_char do |c|
        if c =~ number_pattern
          @ret.push c
          next_word!
        elsif c =~ space_or_line
          break
        else
          raise MyLexerError
        end
      end
    end

    ["lit", @ret.join('')]
  end

  private
  def next_word!
    @index += 1
  end

  def number_pattern
    %r(\d)
  end

  # 半角・全角スペース、タブ、改行
  def space_or_line
    %r( |　|\t|\n)
  end
end

str = %w(
0
100
  100
50   
hoge
)

str.each do |s|
  p MyLexer.new(s).run
end
