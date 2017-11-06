require 'react/server'
require 'react/ref_callback'
require 'native'

module School
  class Index < Hyperloop::Router::Component

    @exercise_with_description = <<-EOS
    [Description]
    My description starts here,
    finish this.
    
    # What is this number more
    # How many select are [select] more [select]
    # One more [select] from? 
    # Make this [input] for what
    # (did, run) [input].
    
    
    Continue with the text
    EOS


    state editor_content: @exercise_with_description
    param editor_default: 'text'
    state :preview

    before_mount do

    end

    after_mount do
      # `console.log(#{refs['editor']}.native)`
      # refs['editor'].focus()
    end

    render(DIV) do
      Sem.Container(style: {marginTop: '2em'}) {
        Sem.Grid {
          Sem.GridRow {
            Sem.GridColumn {
              H1 {'School'}
              Sem.Divider
              div do
                School.EditorPreview(source: state.editor_content)
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
        Sem.TextArea(ref: 'editor', autoHeight: true).on(:change) do |e|
          mutate.editor_content(e.target.value)
        end.on(:key_down) do |e|
          #send_preview(state.editor_content) if send_key?(e)
        end
      end
    end

    def send_key?(e)
      (e.char_code == 13 || e.key_code == 13) && (e.meta_key || e.ctrl_key)
    end

  end

end
