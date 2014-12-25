require 'rails_helper'

describe "Events Index", :js => true do
  describe "prompts for beginning of story if there are no events" do
    before :each do
      visit "/"
    end
    
    it "asks to fill out the form" do
      expect(page).to have_content "When does the story start?"
    end
    
    it "creates the starting event" do
      within("#start_event") do
        fill_in 'event_happened_on', :with => '01/01/0001'
        click_on "Set Date"
      end
      
      expect(page).to have_content '1'
    end
  end
  
  it "displays all events" do
    start_event = create :start_event
    @events = create_list :event, 5
    visit root_path
    
    @events.each do |event|
      expect(page).to have_content event.summary
    end
  end
  
  it "expands to show event details" do
    create :start_event
    e = create :event
    visit root_path
    
    within "#e_#{e.id}" do
      click_on "Details"
      expect(page).to have_content e.details
    end
  end
  
  it "displays events in order of happened_on" do 
    #Needs to be done better.......... 
    create :start_event
    e2014 = create :event, happened_on: "01-01-2014"
    e2013 = create :event, happened_on: "01-01-2013"
    visit root_path
    
    within "#year2014" do
      expect(page).to have_content e2014.summary
    end
    
    within "#year2013" do
      expect(page).to have_content e2013.summary
    end
  end
  
  it "displays events in order of happened_on properly tested"
  
  it "displays time slots" do
    start_event = create :start_event
    visit root_path
    
    (start_event.happened_on.year-5..start_event.happened_on.year+5).each do |y|
      within "#year#{y}" do
        [1,4,7,10].each do |m|
          expect(page).to have_css '[data-month="' + sprintf("%02d", m) + '"]'
        end
      end
    end
  end
  
  it "spans from earliest event to latest event" do 
    create :start_event
    e2014 = create :event, happened_on: "01-01-2000"
    e2013 = create :event, happened_on: "01-01-2050"
    visit root_path
    
    expect(page).to have_css "#year2000"
    expect(page).to have_css "#year2050"
  end
  
  it "infinite scrolls timeslots"
  it "changes display years relatively"
  
  describe "creating an event" do
    before :each do
      start_event = create :start_event
      visit root_path
    end
    
    it "autofills month and year based on timeslot clicked" do
      find('[data-year="2014"][data-month="01"]').click
      
      expect(page).to have_field('event_happened_on', :with => '2014-01-01')
      #find_field('event_happened_on').value.should eq '2014-01-01'
      #expect(page).to have_selector("input[value='2014-01-01']")
    end
    
    it "validates form"
    it "datepicker???? ¯\\ (o.°) /¯"
    it "creates an event and puts it in the timeline" do
      find('[data-year="2014"][data-month="01"]').click
      summary = Faker::Lorem.characters(12)
      details = Faker::Lorem.characters(12)
      
      within "#new_event_modal" do
        
        fill_in 'Summary', with: summary
        fill_in 'Details', with: details
        
        click_button "Save Event"
      end
      
      within "#year2014" do
        expect(page).to have_content summary
      end
    end
    
    it "wysiwig editor"
    it "parses text for characters (waaaaaay later)"
  end
  
  describe "editing an event" do
    it "can drag and drop events to change when it happened"
    it "in place editing???"
  end
  
end