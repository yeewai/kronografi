require 'rails_helper'

describe "Tagging Events", :js => true do
  before :each do
    @world = create :world
    start_event = create :start_event, world: @world
    @event = create :event, world: @world
    visit world_events_path(@world)
  end
  
  it "creates multiple tags separated by commas" #do
  ##Gotta figure out how to test with select2 ~.~
  #  within "#e_#{@event.id}" do
  #    click_link "Edit"
  #  end
  #  
  #  tags = Faker::Lorem.words(4)
  #  within "#edit_event_modal" do
  #    fill_in "Tags", with: tags.join(", ")
  #    click_on "Save Event"
  #  end
  #  
  #  tags.each do |tag|
  #    expect(page).to have_content tag
  #  end
  #end
  
  it "shows autocomplete options" #do
  #  within "#e_#{@event.id}" do
  #    click_link "Edit"
  #  end
  #  
  #  within "#edit_event_modal" do
  #    fill_in "select2-choices", with: @event.tags.first.content[0..2]
  #  end
  #  
  #  expect(page).to have_content @event.tags.first
  #end
  
  it "shows all the tags on the sidebar" do
    tags = create_list :tag, 5, world: @world
    visit world_events_path(@world)
    
    within "#sidenav" do
      click_on "Tags"
      tags.each do |tag|  
        expect(page).to have_content tag.content
      end
    end
  end
  
  describe "filter" do
    before :each do
      @events = create_list :event, 3, world: @world
      @events.first.tags << @events.last.tags.first
      visit world_events_path(@world)
    end
    
    it "shows only events of a tag" do
      within "#sidenav" do
        click_on "Tags"
        #save_screenshot("/Users/yeeeeeeeee/Documents/plotter.png")
        check @events.first.tags.first.content
      end
    
      expect(page).to have_content @events.first.summary
      expect(page).to_not have_content @events.last.summary
    end
    
    it "shows events of any of multiple tag" do
      within "#sidenav" do
        click_on "Tags"
        check @events.first.tags.first.content
        check @events.last.tags.first.content
      end
    
      expect(page).to have_content @events.first.summary
      expect(page).to_not have_content @events[1].summary
      expect(page).to_not have_content @events.last.summary
    end
    
    it "shows all events if no tag selected" do
      within "#sidenav" do
        click_on "Tags"
        check @events.first.tags.first.content
        uncheck @events.first.tags.first.content
      end
      
      @events.each do |event|
        expect(page).to have_content event.summary
      end
    end
    
    describe "characters" do
      before :each do
        @c1 = create :character, world: @world
        @c2 = create :character, world: @world
        @e1 = create :event, details: "@[#{@c1.name}]", world: @world
        @e2 = create :event, details: "@[#{@c2.name}]", world: @world
        @e12 = create :event, details: "@[#{@c1.name}] @[#{@c2.name}]", world: @world
        visit world_events_path(@world)
      end
      
      it "shows only events of a character" do
        within "#sidenav" do
          click_on "Characters"
          check @c1.name
        end
    
        expect(page).to have_content @e1.summary
        expect(page).to_not have_content @e2.summary
      end
    
      it "shows events of any of multiple character" do
        within "#sidenav" do
          click_on "Characters"
          check @c1.name
          check @c2.name
        end
        
        expect(page).to have_content @e12.summary
        expect(page).to_not have_content @e1.summary
        expect(page).to_not have_content @e2.summary
        @events.each do |e|
          expect(page).to_not have_content e.summary
        end
      end
    
      it "shows all events if no character selected" do
        within "#sidenav" do
          click_on "Characters"
          check @c1.name
          uncheck @c1.name
        end
      
        @events.each do |event|
          expect(page).to have_content event.summary
        end
      end
    end
  end
end