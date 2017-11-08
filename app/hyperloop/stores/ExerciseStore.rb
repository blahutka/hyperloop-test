class ExerciseStore < Hyperloop::Store
  state :exercises, scope: :shared, reader: true do
    state.exercises || []
  end

  def self.exercises
    state.exercises
  end

  def self.add_exercise!(name)
    mutate.exercises << name
  end
end