module School
  class Tokenizer

    include Native
    # include Event::Target

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