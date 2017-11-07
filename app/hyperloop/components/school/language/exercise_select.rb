module School
  module Language
    class ExerciseSelect < Hyperloop::Component

      param :editor_content, type: String, allow_nil: true
      param :position, type: Integer
      param :default_option, default: [text: '___', value: 'default']

      param :on_validation, type: Proc, default: nil, allow_nil: true
      param :on_reset_validation, type: Proc, default: nil, allow_nil: true

      state :valid?, default: false
      state changed?: false

      render do
        span do
          Sem.Dropdown(onChange: -> (_, data) {validate(data)},
                       ref: 'dropDown',
                       defaultValue: 'default',
                       options: self.options.to_n,
                       inline: true,
                       error: !(!state.changed? || !state.valid?),
                       disabled: !!state.valid?
          ).on(:click) do |ev|
            puts 'open editor'
          end
        end.on(:double_click) do |ev|
          self.edit_answer()
        end

      end

      def edit_answer
        mutate.valid?(false)
        params.on_reset_validation(true) if params.on_reset_validation
        refs['dropDown'].state.open = true
      end

      def options
        params.default_option + parse_options(params.editor_content)[:options]
      end

      def valid_answer
        parse_options(params.editor_content)[:valid_answer]
      end

      def validate(dropdown)
        _dropdown = Native(`dropdown`)
        mutate.valid? _dropdown.value == self.valid_answer
        params.on_validation({valid: state.valid?, value: _dropdown.value, position: params.position})
        mutate.changed?(true)
      end

      def parse_options(editor_content)
        menu = {options: [], valid_answer: nil}

        return menu if editor_content.blank?

        values = editor_content.split('|').map(&:strip)
        values.each do |option|
          value, is_answer = option.split(',')
          menu[:options] << {text: value, value: value}
          menu[:valid_answer] = value if !!is_answer
        end

        return menu
      end

    end
  end
end