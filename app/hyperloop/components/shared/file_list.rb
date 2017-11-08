class FileList < Hyperloop::Component
  state files: []

  after_mount do
    @pattern = ''
    every(5) {ListFiles.run(pattern: @pattern).then {|files| mutate.files files.split("\n")}}
  end

  render(DIV) do
    INPUT(defaultValue: '')
        .on(:change) {|evt| @pattern = evt.target.value}

    DIV(style: {fontFamily: 'Courier'}) {
      state.files.each do |file|
        DIV {file}
      end
    }
  end
end