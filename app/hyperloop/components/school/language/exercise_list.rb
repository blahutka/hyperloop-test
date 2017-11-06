module School
  module Language
    class ExerciseList < Hyperloop::Component

      param :editor_content, type: String
      param :matchers, default: {
          ExerciseItem: /#\s(.+)/,
      }

      render(OL) do
        # puts params.editor_content
        if params.editor_content.present?
          parse_exercise_item.each do |token|
            # `console.log(#{token}.native)`
            case token.type
              when 'ExerciseItem' then
                School::Language::ExerciseItem(editor_content: token.matches[0])
              else
                span {token.token}
            end
          end
        end
      end

      def parse_exercise_item
        tokenizer = Native(`Tokenizer`)
        tokenizer.parse({parseText: params.editor_content,
                         parsers: params.matchers, deftok: 'invalid'
                        })
      end
    end
  end
end