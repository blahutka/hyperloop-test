module School
  class EditorPreview < Hyperloop::Component
    param :source

    render(DIV) do
      parse(params.source).map(&:as_node).map(&:render)
    end

    def parse(source)
      components = []
      elements = source.split(/\s/)

      elements.each do |el|
        components << case el
                        when /\[btn\]/ then
                          Sem.Button(content: 'Dynamic')
                        when /\[img\]/ then
                          Sem.Image(size: 'small', src: 'http://via.placeholder.com/140x100').on(:click) {alert('ok')}
                        when /\[select:?(.*)?\]/
                          puts $1
                          Sem.Dropdown(header: 'Select specific falue', inline: true,
                                       defaultValue: 'none',
                                       options: [
                                           {text: 'Select Specific word', value: 'none'},
                                           {text: 'opinion', value: 'one'},
                                           {text: 'track', value: 'two'},
                                       ].to_n
                          )
                        else
                          span {" #{el} "}
                      end
      end

      return components
    end
  end
end