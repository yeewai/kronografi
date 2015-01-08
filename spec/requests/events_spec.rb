require 'rails_helper'

describe "Events Index", :js => true do
  before :each do
    @user = create :user
    @user.confirm!
    @world = create :world, user: @user
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on "Log in"
  end
  
  describe "prompts for beginning of story if there are no events" do
    before :each do
      visit world_events_path(@world)
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
    start_event = create :start_event, world: @world
    visit world_events_path(@world)
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
    start_event = create :start_event, world: @world
    @events = create_list :event, 5, world: @world
    visit world_events_path(@world)
    
    @events.each do |event|
      expect(page).to have_content event.summary
    end
  end
  
  it "expands to show event details" do
    create :start_event, world: @world
    e = create :event, world: @world
    visit world_events_path(@world)
    
    within "#e_#{e.id}" do
      click_on "Details"
      expect(page).to have_content e.details
    end
  end
  
  it "displays events in order of happened_on" do 
    #Needs to be done better.......... 
    create :start_event, world: @world
    e2014 = create :event, happened_on: "01-01-2014", world: @world
    e2013 = create :event, happened_on: "01-01-2013", world: @world
    visit world_events_path(@world)
    
    within "#year2014" do
      expect(page).to have_content e2014.summary
    end
    
    within "#year2013" do
      expect(page).to have_content e2013.summary
    end
  end
  
  it "displays events in order of happened_on properly tested"
  
  it "displays time slots" do
    start_event = create :start_event, world: @world
    visit world_events_path(@world)
    
    (start_event.happened_on.year-5..start_event.happened_on.year+5).each do |y|
      within "#year#{y}" do
        [1,4,7,10].each do |m|
          expect(page).to have_css '[data-date="' + sprintf("%.4d", y) + "-" + sprintf("%02d", m) + '-01 12:00"]'
        end
      end
    end
  end
  
  it "spans from earliest event to latest event" do 
    create :start_event, world: @world
    e2014 = create :event, happened_on: "01-01-2000", world: @world
    e2013 = create :event, happened_on: "01-01-2050", world: @world
    visit world_events_path(@world)
    
    expect(page).to have_css "#year2000"
    expect(page).to have_css "#year2050"
  end
  
  describe "expanding the timeline" do
    before :each do
      start_event = create :start_event, world: @world
      visit world_events_path(@world)
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
  
  describe "changing years" do
    before :each do
      start_event = create :start_event, world: @world
      
    end
    
    it "changes display years relatively" do
      visit world_events_path(@world)
      
      click_on "2009"
      within "#year_display" do
        fill_in "year_as", with: "0"
        click_on "Set"
      end
    
      10.times do |i|
        expect(page).to have_content i
      end
    end
    
    it "changes display years relatively" do
      @char = create :character, world: @world, age: 20
      visit world_events_path(@world)
      
      click_on "2009"
      within "#year_display" do
        click_on "Use Character Ages"
        click_on "#{@char.name} (#{@char.age})"
        click_on "Set"
      end
    
      10.times do |i|
        expect(page).to have_content i
      end
    end
  end
  
  describe "creating an event" do
    before :each do
      start_event = create :start_event, world: @world
      visit world_events_path(@world)
    end
    
    it "autofills month and year based on timeslot clicked" do
      find('[data-date="2014-01-01 12:00"]').click
      
      expect(page).to have_field('event_set_happened', :with => '2014-01-01 12:00')
    end
    
    describe "validating the form" do
      before :each do
        @start_event = create :start_event, world: @world
        visit world_events_path(@world)
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
          fill_in "event_set_happened", with: "2014/15/15"
          fill_in "event_summary", with: Faker::Lorem.characters(12)
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
    
    it "creates a milestone and the event has milestone class" do
      find('[data-date="2014-01-01 12:00"]').click
      summary = Faker::Lorem.characters(12)
      
      within "#new_event_modal" do
        
        fill_in 'Summary', with: summary
        select "Milestone", from: "event_kind"
        
        click_button "Save Event"
      end
      
      within "#year2014" do
        expect(page).to have_css ".milestone"
      end
    end
    
    it "wysiwig editor"
    it "parses text for characters (waaaaaay later)"
  end
  
  describe "editing an event" do
    before :each do
      @start_event = create :start_event, world: @world
      @event = create :event, world: @world
      visit world_events_path(@world)
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
      @start_event = create :start_event, world: @world
      @event = create :event, world: @world
      visit world_events_path(@world)
    end
    
    it "doesn't show the removed event" do
      within "#e_#{@event.id}" do
        click_link "Remove"
      end
      
      save_screenshot("/Users/yeeeeeeeee/Documents/plotter_remove.png")
      expect(page).to_not have_content @event.summary
    end
  end
  
  describe "Monthly view" do
    before :each do
      @start_event = create :start_event, world: @world
      @events = create_list :event, 3, world: @world, happened_on: "2014-01-01"
      @other_events = create_list :event, 3, world: @world, happened_on: "2013-01-01"
      visit world_events_path(@world, "2014")
    end
    
    it "shows events in a year" do
      @events.each do |e|
        expect(page).to have_content e.summary
      end
    end
    
    it "does not show events that happened in other years" do
      @other_events.each do |e|
        expect(page).to_not have_content e.summary
      end
    end
    
    it "lets me click through to subsequent years" do
      click_on "<<"
      expect(page).to have_content "2013"
      @other_events.each do |e|
        expect(page).to have_content e.summary
      end
    end
    
    it "creates events in the year" do
      find('[data-date="2014-03-01 12:00"]').click
      summary = Faker::Lorem.characters(12)
      
      within "#new_event_modal" do
        
        fill_in 'Summary', with: summary
        
        click_button "Save Event"
      end
      
      expect(page).to have_content summary
    end
  end
  
  it "versioning"
end