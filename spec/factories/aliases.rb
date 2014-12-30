FactoryGirl.define do
  factory :alias do
    name {generate(:random_string)}
  end

end
