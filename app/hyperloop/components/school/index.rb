require 'react/server'
require 'react/ref_callback'
require 'native'

module School
  class Index < Hyperloop::Router::Component

    state editor_content: ''
    param editor_default: 'text'
    state :preview

    before_mount do
      @exercise_with_description = <<-EOS
      [Description]
      My description starts here, finish this.
      
        # What is this number more
        # How many select are [select true,true | second | third ] more [select one | true,true | third ]
        # One more [select: true,true | second | third] from? 
        # Make this [input] for what
        # (did, run) [input].
      
      
      Continue with the text
      EOS

      mutate.editor_content(@exercise_with_description)
    end

    after_mount do
      refs['editor'].focus()
    end

    render(DIV) do
      Sem.Container(style: {marginTop: '2em'}) {
        Sem.Grid {
          Sem.GridRow {
            Sem.GridColumn {
              H1 {'School'}
              Sem.Divider
              div do
                School.EditorPreview(editor_content: state.editor_content)
              end
              Sem.Divider
              editor
            }
          }

        }
      }
    end

    def editor
      Sem.Form do
        Sem.TextArea(ref: 'editor',
                     defaultValue: @exercise_with_description,
                     autoHeight: true)
            .on(:change) {|ev| mutate.editor_content(ev.target.value)}
            .on(:key_down) {}
      end
    end

    def send_key?(e)
      (e.char_code == 13 || e.key_code == 13) && (e.meta_key || e.ctrl_key)
    end

  end

end
