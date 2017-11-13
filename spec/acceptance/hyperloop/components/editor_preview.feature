@javascript @keep_session @debugger[]
Feature: School::EditorPreview is component, which receives user input as easy formatted text.
  The user text input is converted to html markup which is displayed back as user preview.

  Background:
    Given component "School::EditorPreview" with text
      """
      [Description]
      My *description* starts here, *finish* this. More

        # What is this number more [select true,true | two | third]
        # How many select are [select true,true | second | third ] more [select one | true,true | third ]
        # One more [select: true,true | second | third] from?
        # Make this [input] for what
        # (did, run) [input].

      Continue with the text
      """
    And get component

  Scenario: Renders list of exercises
    When display exercises
    Then it has list of 5 exercises

  Scenario Outline: Student answers question 1
    Given question number <Question Number>
    When student select answer "<Selected Answer>"
    Then student should see question stats "<Question Stats>"
    Examples:
      | Question Number | Selected Answer | Question Stats |
      | 1               | two             | 0% (1/1)       |
      | 1               | true            | 50% (2/1)      |

  Scenario Outline: Student answers question 2
    Given question number <Question Number>
    When student select answer "<Selected Answer>"
    Then student should see question stats "<Question Stats>"
    Examples:
      | Question Number | Selected Answer | Question Stats |
      | 2               | true,one        | 0% (2/2)       |
      | 2               | ,true           | 67% (3/2)      |

