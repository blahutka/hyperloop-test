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
        School::Tokenizer.parse(parse_text: params.editor_content,
                                parsers: params.matchers)
      end
    end
  end
end