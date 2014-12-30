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
        fill_in 'event_set_happened', :with => '01/01/0001'
        click_on "Set Date"
      end
      
      expect(page).to have_content '1'
    end
  end
  
  it "changes start date" do
    start_event = create :start_event
    visit root_path
    click_on "Change Start Date"
    
    within "#start_event" do
      fill_in 'event_set_happened', :with => '01/01/0100'
      click_on "Set Date"
    end
    
    within "#year100" do
      expect(page).to have_content 'Story Starts'
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
          expect(page).to have_css '[data-date="' + sprintf("%.4d", y) + "-" + sprintf("%02d", m) + '-01 12:00"]'
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
  
  describe "expanding the timeline" do
    before :each do
      start_event = create :start_event
      visit root_path
    end
    
    it "adds 10 years before the timeline" do
      click_on "See 10 years earlier"
      expect(page).to have_css "a[data-date='1999-01-01 12:00']"
    end
    
    it "adds 10 years after the timeline" do
      click_on "See 10 years later"
      expect(page).to have_css "a[data-date='2019-01-01 12:00']"
    end
  end
  
  it "changes display years relatively" do
    start_event = create :start_event
    visit root_path
      
    click_on "2009"
    within "#year_display" do
      fill_in "year_as", with: "0"
      click_on "Set"
    end
    
    10.times do |i|
      expect(page).to have_content i
    end
  end
  
  describe "creating an event" do
    before :each do
      start_event = create :start_event
      visit root_path
    end
    
    it "autofills month and year based on timeslot clicked" do
      find('[data-date="2014-01-01 12:00"]').click
      
      expect(page).to have_field('event_set_happened', :with => '2014-01-01 12:00')
    end
    
    describe "validating the form" do
      before :each do
        @start_event = create :start_event
        visit root_path
        click_on "New Event"
      end
      
      it "does not let you submit the form if there is no summary" do
        within "#new_event_modal" do
          fill_in "Happened On", with: "2014-01-01"
          expect(page).to have_button('Save Event', disabled: true)
        end
      end
      
      it "does not let you submit the form if there is no date" do
        within "#new_event_modal" do
          fill_in "event_summary", with: Faker::Lorem.characters(12)
          expect(page).to have_button('Save Event', disabled: true)
        end
      end
      
      it "does not let you submit the form if the date is not formatted correctly" do
        within "#new_event_modal" do
          fill_in "event_summary", with: Faker::Lorem.characters(12)
          fill_in "event_set_happened", with: "2014/01/01"
          expect(page).to have_button('Save Event', disabled: true)
        end
      end
    end
    
    it "creates an event and puts it in the timeline" do
      find('[data-date="2014-01-01 12:00"]').click
      summary = Faker::Lorem.characters(12)
      
      within "#new_event_modal" do
        
        fill_in 'Summary', with: summary
        
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
    before :each do
      @start_event = create :start_event
      @event = create :event
      visit root_path
    end
    
    it "can drag and drop events to change when it happened"
    it "can edit" do
      within "#e_#{@event.id}" do
        click_link "Edit"
      end

      summary = Faker::Lorem.characters(12)
      
      within "#edit_event_modal" do
        fill_in 'Summary', with: summary
        click_on "Save Event"
      end
      
      within "#year2014" do
        expect(page).to have_content summary
      end
    end
  end
  
  describe "removing events" do
    before :each do
      @start_event = create :start_event
      @event = create :event
      visit root_path
    end
    
    it "doesn't show the removed event" do
      within "#e_#{@event.id}" do
        click_link "Remove"
      end
      
      expect(page).to_not have_content @event.summary
    end
  end
  
  it "versioning"
end