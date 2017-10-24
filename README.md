# my-compiler

Compiling for Original language.

## Usage

language statement.

```
if ( 10 == 1 + 9 ) {
  10
}
```

Run.

```ruby
require './lexer.rb'
require './parser.rb'

str = <<EOF
if ( 10 == 1 + 9 ) {
  10
}
EOF

# lexer
lex = MyLexer.new(str).run

# parser
p MyParser.new(lex).run # => ["if", ["==", ["lit", 10], ["+", ["lit", 1], ["lit", 9]]], ["lit", 10]]
```

## functions

- [x] Number literal `1`
- [x] String `"foo"`
- [x] Calculation `10 + 20 * 30 / 40`
  - `+, -, *, /, %`
- [x] if 

```
if ( ... ) {
  ...
}
```

- [x] multi line

```
10 + 20
if ( 100 = 100 ) {
  "OK"
}
```

- [ ] else
- [ ] elseif
- [ ] for
- [ ] variable
- [ ] function
- [ ] and more... :innocent:

## Presentation Materials

here ( **Japanese** ) -> [雰囲気でコンパイラを書いたら大変だった話 - Speaker Deck](https://speakerdeck.com/mizukmb/fen-wei-qi-dekonpairawoshu-itarada-bian-datutahua)
