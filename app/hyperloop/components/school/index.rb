require 'react/server'
require 'react/ref_callback'

module School
  class Index < Hyperloop::Router::Component
    state editor_content: 'text [btn] [img] What is your [select:one:true,two:false] for your question?'
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
