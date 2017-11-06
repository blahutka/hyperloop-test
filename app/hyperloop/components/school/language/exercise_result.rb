module School
  module Language
    class ExerciseResult < Hyperloop::Component
      param :tries, type: Integer
      param :answers, type: Integer
      param :success, type: Integer
      state percent: 0

      after_update do
        # puts props
      end

      render(SPAN) do
        if done?
          Sem.Button(size: 'mini', label: "#{score}% (#{tries_count}/#{params.answers})", labelPosition: 'left', icon: 'check', color: 'green')
        else
          Sem.Button(size: 'mini', label: "#{score}% (#{tries_count}/#{params.answers})", labelPosition: 'left', icon: 'edit')
        end
      end

      def percent_done
        num = ((params.success * 100)/ params.answers)
        num > 0 ? num.round : 0
      end

      def score
        num = (params.tries >= params.answers) && (params.success == params.answers) ? ((params.answers * 100) / params.tries) : 0
        num > 0 ? num.round : 0
      end

      def tries_count
        params.tries
      end

      def doneIcon
        Sem.Icon(size: 'large', name: 'check', color: 'green')
      end

      def done?
        params.answers == params.success
      end
    end
  end
end