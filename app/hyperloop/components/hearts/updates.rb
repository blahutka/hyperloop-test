class Updates < Hyperloop::Component
  param :heart
  param :category

  render(DIV) do
    panels = []

    @data = Update.for_heart_category(params.heart.id, params.category)
    @data.reverse.each do |update|
      panels << {title: UpdateTitle(update: update).as_node,
                 content: UpdatePanel(update: update).as_node,
                 key: update.id.to_s
      }
    end

    Sem.Divider{}
    Sem.Button(primary: true, content: 'Like', icon: 'heart', labelPosition: 'right',
               label: { as: 'a', basic: true, content: '2,048' }.to_n)

    Sem.Button(content: 'Like', icon: 'heart', labelPosition: 'right',
               label: { as: 'a', basic: true, content: '2,048' }.to_n)

    Sem.Accordion(styled: true, panels: panels.to_n, fluid: true) if @data.loaded? && panels.any?

    Sem.Loader(active: !@data.loaded?, inline: 'centered')

  end
end

class UpdateTitle < Hyperloop::Component
  param :update
  render do
    SPAN {
      SPAN {"Update from #{params.update.member.full_name} "}
      TimeAgo(date: params.update.updated_at)
    }
  end
end

class UpdatePanel < Hyperloop::Component
  param :update

  render do
    SPAN {params.update.body}
  end
end
