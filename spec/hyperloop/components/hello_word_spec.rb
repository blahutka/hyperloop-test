require 'rails_helper'

describe 'HelloWord', type: :feature, js: true do
  it 'has the correct content' do
    mount 'HelloWord', name: 'Fred'
    expect(page).to have_content('Hello there Fred')
  end

  it 'can the mount a component defined in mounts code block' do
    mount 'ShowOff' do
      class ShowOff < Hyperloop::Component
        render(DIV) { 'Now how cool is that???' }
      end
    end
    expect(page).to have_content('Now how cool is that???')
  end
end