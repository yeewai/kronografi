FactoryGirl.define do
  factory :alias do
    world
    name {generate(:random_string)}
  end

end
