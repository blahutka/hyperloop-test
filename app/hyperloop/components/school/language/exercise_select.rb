module School
  module Language
    class ExerciseSelect < Hyperloop::Component

      param :valid_answer
      param :on_validation, type: Proc, default: nil, allow_nil: true
      param :position, type: Integer

      state :valid?, default: false
      state changed?: false
      state open: false

      render do
        span do
          Sem.Dropdown(onChange: -> (_, data) {validate(data)},
                       inline: true,
                       defaultValue: 'none',
                       error: !(!state.changed? || !state.valid?),
                       disabled: !!state.valid?,
                       ref: 'dropdown',
                       options: [
                           {text: '_____', value: 'none'},
                           {text: 'was', value: 'was'},
                           {text: 'were', value: 'were'},
                           {text: 'did', value: 'did'},
                           {text: 'done', value: 'done'},
                       ].to_n
          ).on(:click) do |ev|
            puts 'open editor'
          end
        end.on(:double_click) do |ev|
          mutate.valid?(false)
          refs['dropdown'].state.open = true
        end

      end

      def validate(data)
        _data = Native(`data`)
        mutate.valid? _data.value == params.valid_answer
        params.on_validation({valid: state.valid?, value: _data.value, position: params.position})
        mutate.changed?(true)
      end

    end
  end
end