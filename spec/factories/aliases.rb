FactoryGirl.define do
  factory :alias do
    world
    character
    name {generate(:random_string)}
  end

end
