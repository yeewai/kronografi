FactoryGirl.define do
  factory :tag do
    content {generate(:random_string)}
    description {generate(:random_string)}
    slug "MyString"
  end

end
