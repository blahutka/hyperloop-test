module School
  class EditorPreview < Hyperloop::Component
    param :editor_content

    after_update do
      # `console.log(#{params.tokenizer}.native)`
    end

    render(DIV) do
      to_components
    end

    def to_components
      School::Language::Exercise(editor_content: params.editor_content)
    end
  end

end