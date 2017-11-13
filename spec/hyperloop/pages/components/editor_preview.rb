module Pages
  module Components

    class EditorPreview < SitePrism::Section

      class AnswerMenu < SitePrism::Section
        def open
          root_element.click()
        end

        def select(opts)
          within(root_element) do
            find('.item', opts).click
          end
        end
      end

      class Question < SitePrism::Section
        sections :answer_menus, AnswerMenu, '.ui.dropdown'
        element :stats, '.ui.label'
        element :result_success, '.ui.button.green'
      end

      class QuestionList < SitePrism::Section
        sections :questions, Question, 'li'
      end

      section :exercise, QuestionList, 'ol'
    end
  end
end
