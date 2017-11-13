require 'rails_helper'
require 'turnip/rspec'
require 'turnip/capybara'

# Dir.glob("spec/acceptance/steps/**/*steps.rb") {|f| require "./#{f}"}
Dir.glob("spec/acceptance/steps/**/*steps.rb") {|f| load f, true}

RSpec.configure do |config|
  #config.include(EditorPreview2)

  config.after(type: :feature, keep_session: true) do
    # Keep all session variables present for tagged :keep_session scenario
    Capybara.current_session.instance_variable_set(:@touched, false)
    # Flag that is used in steps to mount or not component
    page.instance_variable_set('@hyper_spec_keep_mounted', true)
  end

  config.after(type: :feature) do
    page.instance_variable_set('@hyper_spec_keep_mounted', false)
  end

  config.after(:each, selenium_with_firebug: true) do |scenario|
    # pp scenario.metadata
    # pp scenario.metadata[:full_description]
    # pp scenario.metadata[:line_number]
    # pp scenario.metadata[:scoped_id]
    # pp scenario.metadata[:example_group][:line_number]
    # pp scenario.metadata[:execution_result]
    step_descriptions = scenario.metadata[:full_description].split("\n")
    match = scenario.metadata.keys.map {|m| $1 if m =~ /debugger\[(.*)\]/}.compact
    lines = match.first.split(',') if match.any?
    last_descriptions = step_descriptions.last(lines.first.to_i)

    failed = scenario.exception ? true : false

    status = failed ? "console.log('%cFAILED', 'color:red;font-weight:bold;')" : "console.log('%cOK', 'color:green;font-weight:bold;')"

    if lines && failed
      page.evaluate_script("#{status}")
      pause("*** debugger::stop ***\n#{step_descriptions[1..-1].join("\n")}")
    elsif lines
      page.evaluate_script("#{status}")
      pause()
    end
  end

end
