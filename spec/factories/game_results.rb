# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_result do
    user

    after(:build) do |result|
      result.game = GoFishGame.new(result.user.name, "Bob") # FactoryGirl.build(:game)
    end
  end
end

