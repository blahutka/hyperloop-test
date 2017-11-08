module School
  class Tokenizer

    EXERCISE = {
        Description: /\[Description\](.*(?:\r?\n(?!\s*\r?\n).*)*)/,
        List:  /#\s(.*(?:\r?\n(?!\s*\r?\n).*)*)/,
        Item: /#\s(.+)/,
    }.freeze

    STYLE = {
        Bold: /\*((?:(?!\*).)*)\*((?:(?!\*).)*)/,
    }

    GENERAL = {
        Select: /\[select:?([^\]]+)?\]/,
        Input: /\[input\]/
    }.freeze

    def self.parse(parse_text:, parsers:, deftoken: 'unknown')
      @tokenizer = Native(`Tokenizer`)
      tokens = @tokenizer.parse(parseText: parse_text,
                       parsers: parsers.to_n,
                       deftok: deftoken)
      %x{
       return tokens;
      }
    end
  end
end