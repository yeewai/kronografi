FactoryGirl.define do
  factory :world do
    name {generate(:random_string)}
    description {generate(:random_string)}
    user
  end

end
