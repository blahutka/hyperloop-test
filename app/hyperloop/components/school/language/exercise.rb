module School
  module Language
    class Exercise < Hyperloop::Component

      param :editor_content, type: String
      param :matcher_exercise, default: {
          Description: /\[Description\](.*(?:\r?\n(?!\s*\r?\n).*)*)/,
          ExerciseList: /#\s(.*(?:\r?\n(?!\s*\r?\n).*)*)/
      }

      before_mount do
       # puts params.matcher_exercise
      end

      render(DIV) do
        if params.editor_content.present?
          parse_exercise.each do |token|
            # `console.log(#{token}.native)`
            case token.type
              when 'Description' then Description(text: token.matches[0])
              when 'ExerciseList' then School::Language::ExerciseList(editor_content: token.token)
              else
                SPAN{token.token}
            end
          end
        end
      end

      def parse_exercise
        School::Tokenizer.parse(parse_text: params.editor_content,
                             parsers: params.matcher_exercise)
      end

      class Description < Hyperloop::Component
        param :text, type: String

        render(P) do
          STRONG{ params.text }
        end
      end
    end
  end
end