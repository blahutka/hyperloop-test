module School
  class EditorPreview < Hyperloop::Component
    param :source

    after_update do
      # `console.log(#{params.tokenizer}.native)`
    end

    render(DIV) do
      to_components
    end

    def to_components
      School::Language::Exercise(editor_content: params.source)
    end
  end

end