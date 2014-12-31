FactoryGirl.define do
  factory :tag do
    world
    content {generate(:random_string)}
    description {generate(:random_string)}
    slug "MyString"
  end

end
