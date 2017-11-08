require 'react/ref_callback'

module School
  class Index < Hyperloop::Router::Component

    state editor_content: ''
    param editor_default: 'text'
    state :preview

    before_mount do
      @exercise_with_description = <<-EOS
      [Description]
      My *description* starts here, *finish* this.
      
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
              FileList()
              Sem.Divider
              div do
                School.EditorPreview(editor_content: state.editor_content)
              end.on(:click) {
                puts 'click'
                ExerciseStore.add_exercise!('click')
              }
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
            .on(:select) {|ev|
              %x{
              String.prototype.replaceAt=function(index, replacement) {
                  return this.substr(0, index) +'*'+replacement+'*'+ this.substr(index + replacement.length);
                }
                var start = #{ev}.native.target.selectionStart;
                var end = #{ev}.native.target.selectionEnd;
                var selection = #{ev}.native.target.value.substring(start, end);
                var new_str = #{ev}.native.target.value.replaceAt(start, selection)
              }

              ExerciseStore.add_exercise!(`start`)

              #`#{ev}.native.target.value = new_str` if `end` > `start`
            }
      end
    end

    def send_key?(e)
      (e.char_code == 13 || e.key_code == 13) && (e.meta_key || e.ctrl_key)
    end

  end

end
