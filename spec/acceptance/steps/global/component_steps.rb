module Turnip::Steps
  step 'component :component with text' do |component, editor_content|

    mounted = page.instance_variable_get('@hyper_spec_mounted')
    keep_mounted = page.instance_variable_get('@hyper_spec_keep_mounted')

    if keep_mounted
      # Mount component only once
      mount(component, editor_content: editor_content) unless mounted
    else
      mount(component, editor_content: editor_content)
    end

  end
end