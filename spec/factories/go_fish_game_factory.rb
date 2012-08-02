FactoryGirl.duplicate_attribute_assignment_from_initialize_with = false

FactoryGirl.define do
  factory :game, :class => GoFishGame do
    initialize_with { new("Christian", "Bob") }
  end
end
