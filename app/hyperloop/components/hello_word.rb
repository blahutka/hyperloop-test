class HelloWord < Hyperloop::Component
  param :name
  render(DIV) do
    "Hello there #{params.name}"
  end
end