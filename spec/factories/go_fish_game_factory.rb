FactoryGirl.duplicate_attribute_assignment_from_initialize_with = false

FactoryGirl.define do
  factory :game, :class => GoFishGame do
    initialize_with { new("Christian", "Bob") }
  end

  # factory :ended_game_with_single_winner, :parent => :game do
  #   after(:build) do |game|
  #     game.stubs(:end?).returns(true)
  #     game.stubs(:winner).returns(GoFishPlayer.new("Christian"))
  #   end
  # end
end

