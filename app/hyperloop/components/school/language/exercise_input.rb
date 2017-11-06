module School
  module Language
    class ExerciseInput < Hyperloop::Component

      param :valid_answer
      param :on_validation, type: Proc, default: nil, allow_nil: true
      param :position, type: Integer

      state :valid?, default: false
      state changed?: false
      state show_hint?: false

      before_mount do
        @current_answer = ''
      end

      render(SPAN) do
        Sem.Form(as: 'span') do
          Sem.FormField(as: 'span', inline: true) do
            Sem.Input(size: 'small',
                      class: 'exercise-input',
                      disabled: !!state.valid?,
                      transparent: true,
                      placeholder: '.'*150,
                      onChange: -> (_, data) {validate(data)}

            ).on(:key_down) do |e|
              mutate.show_hint?(!state.show_hint?) if send_key_hint?(e)
            end.on(:double_click) do |ev|
              mutate.valid?(false)
            end
            Sem.Label(as: 'span', pointing: 'left') {closest_hint} if state.show_hint?
          end
        end
      end

      def validate(data)
        _data = Native(`data`)
        mutate.valid? _data.value == params.valid_answer
        @current_answer = _data.value
        params.on_validation({valid: state.valid?, value: _data.value, position: params.position})
        mutate.changed?(true)
      end

      def send_key_hint?(e)
        (e.char_code == 72 || e.key_code == 72) && (e.meta_key || e.ctrl_key)
      end

      def closest_hint
        hints = []
        valid_answer = params.valid_answer.split(' ')
        current_answer = @current_answer.split(' ')
        text_more = valid_answer.size == current_answer.size ? '' : '...'

        @current_answer.split(' ').each_with_index do |word, i|
          if valid_answer[i] == word
            hints << valid_answer[i]
          else
            hints << valid_answer[i]
            break
          end
        end

        return hints.join(' ') + text_more
      end

    end
  end
end