FactoryGirl.define do
  factory :concept do
    world
    name {generate(:random_string)}
    description {generate(:random_string)}
    age 1
    nicknames {generate(:random_string)}
  end

end
