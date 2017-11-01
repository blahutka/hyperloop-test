class HeartStore < Hyperloop::Store
  state :heart_id
  state :category
  state :status, scope: :class

  module HeartOperations

    class Load < Hyperloop::Operation
      param :category
      param :heart_id, type: Integer

      outbound :result
      outbound :status

      #step { HeartStore.status!('loading')}
      step { Update.for_heart_category(params.heart_id, params.category) }
      step do |response|
        #HeartStore.status!('done')
        return params.result = response
      end
      #step {|r| puts params }
      failed { |r| puts r }

    end
  end

  def self.status!(text)
    mutate.status(text)
  end

  def self.load(heart_id, category)
    HeartOperations::Load.run(heart_id: heart_id, category: category)
  end

  receives HeartOperations::Load do |params|
    puts 'received'
    puts params
  end

end