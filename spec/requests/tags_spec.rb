require 'rails_helper'

describe "Tagging Events", :js => true do
  before :each do
    start_event = create :start_event
    @event = create :event
    visit root_path
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
    tags = create_list :tag, 5
    visit root_path
    
    within "#sidenav" do
      click_on "Tags"
      tags.each do |tag|  
        expect(page).to have_content tag.content
      end
    end
  end
  
  describe "filter" do
    before :each do
      @events = create_list :event, 3
      visit root_path
    end
    
    it "shows only events of a tag" do
      within "#sidenav" do
        click_on "Tags"
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
      expect(page).to have_content @events.last.summary
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
  end
end