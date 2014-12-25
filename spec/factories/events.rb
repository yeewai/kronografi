FactoryGirl.define do
  sequence(:random_string) {|n| Faker::Lorem.characters(12)}
  sequence(:random_date) {|n| "2014-12-#{n}"}
  
  factory :event do
    summary {generate(:random_string)}
    details {generate(:random_string)}
    happened_on "2014-12-24"
    
    factory :start_event do
      summary "Story Starts"
    end
  end

end
