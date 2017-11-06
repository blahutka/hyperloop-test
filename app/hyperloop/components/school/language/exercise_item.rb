module School
  module Language
    class ExerciseItem < Hyperloop::Component
      param :editor_content
      param :component_matchers, default: {
          Select: /\[select\]/,
          Input: /\[input\]/
      }
      state valid_count: 0

      before_update do
        @answers = []
      end

      before_mount do
        @answers = []
        @success = []
        @tries = []
      end

      def on_validation
        -> (data) {
          #puts 'validating'
          # puts data
          @success << data[:position] if data[:valid]
          @success.uniq!
          @tries << data[:value]
          mutate.valid_count(@success.length)
          # puts 'valid count', state.valid_count
        }
      end


      render LI, class: 'exercise-item' do
        if params.editor_content.present?
          parse_exercise_item_text.each_with_index do |token, i|
            # `console.log(#{token}.native)`
            case token.type
              when 'Select' then
                @answers << 1
                School::Language::ExerciseSelect(position: i, valid_answer: 'did', on_validation: on_validation)
              when 'Input' then
                @answers << 1
                School::Language::ExerciseInput(position: i, valid_answer: 'valid answer, is longer', on_validation: on_validation)
              else
                SPAN {token.token}
            end
          end

          School::Language::ExerciseResult(success: state.valid_count, answers: @answers.length, tries: @tries.count) if @answers.any?
        end
      end

      def parse_exercise_item_text
        tokenizer = Native(`Tokenizer`)
        tokenizer.parse({parseText: params.editor_content,
                         parsers: params.component_matchers, deftok: 'invalid'
                        })
      end

    end
  end
end