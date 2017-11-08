module School
  module Language
    class ExerciseItem < Hyperloop::Component
      param :editor_content
      param :component_matchers, default: {
          Select: School::Tokenizer::GENERAL[:Select],
          Input: School::Tokenizer::GENERAL[:Input]
      }
      state valid_count: 0

      before_update do
        @answers_count = 0
      end

      before_mount do
        @answers_count = 0
        @success = []
        @tries = []
      end

      def on_validation
        lambda { |data|
          @success << data[:position] if data[:valid]
          @success.uniq!
          @tries << data[:value]
          mutate.valid_count(@success.length)
        }
      end

      def reset_validation
        lambda {
          @answers_count = 0
          @tries = []
          @success = []
          mutate.valid_count(@success.length)
        }
      end


      render LI, class: 'exercise-item' do
        if params.editor_content.present?
          parse_exercise_item_text.each_with_index do |token, i|
            # `console.log(#{token}.native)`
            case token.type
              when 'Select' then
                @answers_count += 1

                School::Language::ExerciseSelect(position: i,
                                                 editor_content: (token.matches.any? ? token.matches[0] : nil),
                                                 on_validation: on_validation,
                                                 on_reset_validation: reset_validation)
              when 'Input' then
                @answers_count += 1
                School::Language::ExerciseInput(position: i, valid_answer: 'valid answer, is longer', on_validation: on_validation)
              else
                SPAN {token.token}
            end
          end

          School::Language::ExerciseResult(success: state.valid_count, answers: @answers_count, tries: @tries.count) if @answers_count > 0
        end
      end

      def parse_exercise_item_text
        School::Tokenizer.parse(parse_text: params.editor_content,
                                parsers: params.component_matchers)
      end

    end
  end
end