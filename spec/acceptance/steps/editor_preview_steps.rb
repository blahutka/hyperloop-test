require_relative '../../hyperloop/pages/components/editor_preview'

module Turnip::Steps

  step 'get component' do
    size_window(:tablet)
    @component = Pages::Components::EditorPreview.new(nil, find('body'))
  end

  step 'display exercises' do
    expect(@component).to have_exercise
  end

  step 'it has list of :number exercises' do |number|
    expect(@component.exercise.questions.size).to eq(number.to_i)
  end

  step 'question number :number' do |number|
    index = number.to_i - 1
    @selected_question = @component.exercise.questions[index]
  end

  step 'student select answer ":answers"' do |answers|
    answers = answers.split(',')
    answers.each_with_index do |answer, i|
      next if answer.blank?

      answer_menu = @selected_question.answer_menus[i]
      answer_menu.open()
      answer_menu.select(text: answer)
    end
  end

  step 'student should see question stats ":stats"' do |stats|
    expect(@selected_question.stats.text).to eq(stats)
  end

  # step 'render component ":component" with params:' do |component_name, table|
  #   params = table.hashes.first
  #   mount(component_name, params)
  # end
  #
  # step 'I should see ":result"' do |result|
  #   expect(page.text).to eq(result)
  # end
end