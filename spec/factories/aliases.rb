FactoryGirl.define do
  factory :alias do
    world
    concept
    name {generate(:random_string)}
  end

end
