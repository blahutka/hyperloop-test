require '../tokenizer'

module School
  module Language
    class Exercise < Hyperloop::Component

      param :editor_content, type: String
      param :matcher_exercise, default: {
          Description: School::Tokenizer::EXERCISE[:Description],
          ExerciseList: School::Tokenizer::EXERCISE[:List]
      }

      before_mount do
        # puts params.matcher_exercise
      end

      after_update do
        puts 'exercise', 'update'
      end

      render(DIV) do
        if params.editor_content.present?
          parse_exercise.each do |token|
            # `console.log(#{token}.native)`
            case token.type
              when 'Description' then
                Description(text: token.matches[0])
              when 'ExerciseList' then
                School::Language::ExerciseList(editor_content: token.token)
              else
                SPAN {token.token}
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
        param :matcher, default: {
            Bold: School::Tokenizer::STYLE[:Bold]
        }

        render(P) do
          parse_text.each do |token|
            # `console.log(#{token}.native)`
            case token.type
              when 'Bold' then
                bold_text, rest_text = token.matches
                [strong{bold_text}, span{rest_text}]
              else
                span{ token.token} if token.token.present?
            end
          end
        end

        def parse_text
          School::Tokenizer.parse(parse_text: params.text,
                                  parsers: params.matcher)
        end
      end
    end
  end
end