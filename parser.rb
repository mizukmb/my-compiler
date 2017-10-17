class MyParser
  class MyParserError < StandardError; end

  def initialize(tokenized_list)
    @tokenized_list = tokenized_list
    @index = 0
  end

  def run
    statement
  end

  private

  # 複文
  def statement
    ret = []
    tmp = vocab

    if !get_next_token.nil? and
        get_next_token.first == newline
      next_token!

      ret.push tmp

      until get_next_token.nil?
        if get_next_token.first == number_literal

          next_token!
          ret.push vocab
        end

        next_token!
      end
      ret.unshift 'stmts'
    else
      ret = tmp
    end

    ret
  end

  # 比較演算子
  def vocab
    ret = expr

    while !get_next_token.nil? and
          get_next_token.first =~ comparison
      next_token!
      ret = [token[1], ret]
      next_token!
      ret.push expr
    end

    ret
  end

  # 加算、減算演算子
  def expr
    ret = term

    while !get_next_token.nil? and
          get_next_token.first =~ plus_or_minus
      next_token!
      ret = [token[1], ret]
      next_token!
      ret.push term
    end

    ret
  end

  # 乗算、割算、剰余演算子
  def term
    ret = factor

    while !get_next_token.nil? and
          get_next_token.first =~ multi_or_divide
      next_token!
      ret = [token[1], ret]
      next_token!
      ret.push factor
    end

    ret
  end

  # 数値リテラル
  def factor
    if token.first == number_literal
      token
    elsif !get_next_token.nil? and
          get_next_token.first == newline
      token
    else
      raise MyParserError
    end
  end

  def token
    @tokenized_list[@index]
  end

  def get_next_token
    @tokenized_list[@index + 1]
  end

  def next_token!
    @index += 1
  end


  def number_literal
    'lit'
  end

  def newline
    'newline'
  end

  def plus_or_minus
    %r(operator_plus|operator_minus)
  end

  def multi_or_divide
    %r(operator_multi|operator_divide|operator_surplus)
  end

  def comparison
    %r(operator_gt|operator_ge|operator_eq|operator_le|operator_lt|operator_ne)
  end
end
