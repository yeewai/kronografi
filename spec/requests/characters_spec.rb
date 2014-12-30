require 'rails_helper'

describe "Characters", js: true do
  it "creates new characters" do
    visit new_character_path
    
    n = Faker::Lorem.characters(12)
    n1 = Faker::Lorem.characters(12)
    n2 = Faker::Lorem.characters(12)
    age = Faker::Number.number(1)
    
    fill_in "Name", with: n
    fill_in "Age", with: age
    fill_in "Nicknames", with: "#{n1}, #{n2}"
    
    click_on "Save"
    
    [n, n1, n2, age].each do |item|
      expect(page).to have_content item
    end
  end
  
  it "doesn't let you use nonunique names" do
    n = Faker::Lorem.characters(12)
    create :character, name: n
    visit new_character_path

    fill_in "Age", with: 1
    fill_in "Nicknames", with: n
    expect(page).to have_button('Save', disabled: true)
  end
  
  it "doesn't let you use nonunique nicknames" do
    n = Faker::Lorem.characters(12)
    create :alias, name: n
    visit new_character_path

    fill_in "Age", with: 1
    fill_in "Nicknames", with: n
    expect(page).to have_button('Save', disabled: true)
  end
  
  it "edits characters" do
    @char = create :character
    visit character_path(@char)
    click_on "Edit"
    
    n1 = Faker::Lorem.characters(12)
    n2 = Faker::Lorem.characters(12)
    age = Faker::Number.number(1)

    fill_in "Age", with: age
    fill_in "Nicknames", with: "#{n1}, #{n2}"
    
    click_on "Save"
    
    [n1, n2, age].each do |item|
      expect(page).to have_content item
    end
  end
  
  describe "linking to events" do
    before :each do
      @start_event = create :start_event
      @char = create :character
      @event = create :event
      visit root_path
      
      within "#e_#{@event.id}" do
        click_link "Edit"
      end
    end
    
    it "links to events by mentioning character name in the details" #do
    #  within "#edit_event_modal" do
    #    #within_frame "event_details_#{@event.id}_ifr" do
    #      find("[data-id='event_details_#{@event.id}']").set("@[#{@char.name}]")
    #      #fill_in "event_details_#{@event.id}", :with =>"@[#{@char.name}]"
    #      #end  
    #    click_on "Save Event"
    #  end
    #  
    #  within "#e_#{@event.id} .char_list" do
    #    expect(page).to have_content @char.name
    #  end
    #end
    
    it "links to events by mentioning character name in the summary" do
      within "#edit_event_modal" do
        fill_in 'Summary', with: "@[#{@char.name}]"
        click_on "Save Event"
      end
      
      within "#e_#{@event.id} .char_list" do
        expect(page).to have_content @char.name
      end
    end
    
    it "links to events by mentioning character nickname in the summary" do
      within "#edit_event_modal" do
        fill_in 'Summary', with: "@[#{@char.aliases.first.name}]"
        click_on "Save Event"
      end
      
      within "#e_#{@event.id} .char_list" do
        expect(page).to have_content @char.name
      end
    end
    
    describe "displaying event" do
      before :each do
        within "#edit_event_modal" do
          fill_in 'Summary', with: "@[#{@char.name}]"
          click_on "Save Event"
        end
      end
      
      it "doesn't show the @[]" do
        within "#e_#{@event.id}" do
          expect(page).to_not have_content "@["
        end
      end
      
      it "links to the character" do
        within "#e_#{@event.id} .char_list" do
          click_on @char.name
        end
        
        expect(page).to have_content @char.name
        expect(page).to have_content @char.description
      end
      
      it "links to create a new character for invalid char names" do
        n = Faker::Lorem.characters(12)
        within "#e_#{@event.id}" do
          click_link "Edit"
        end
        
        within "#edit_event_modal" do
          fill_in 'Summary', with: "@[#{n}]"
          click_on "Save Event"
        end
        within "#e_#{@event.id}" do
          click_on n
        end
        
        expect(page).to have_selector("input[value='#{n}']")
      end
    end
    
    describe "Creating a character previously mentioned" do
      it "links to event if matching name is found" do
        n = Faker::Lorem.characters(12) 
        e = create :event, details: "@[#{n}]"
        visit new_character_path

        fill_in "Age", with: "1"
        fill_in "Name", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
        
      end
      
      it "links to event if matching case insensitive name is found" do
        n = Faker::Lorem.characters(12) 
        e = create :event, details: "@[#{n.downcase}]"
        visit new_character_path

        fill_in "Age", with: "1"
        fill_in "Name", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
        
      end
      
      it "links to event if matching nickname is found" do
        n = Faker::Lorem.characters(12) 
        e = create :event, details: "@[#{n}]"
        visit new_character_path
        
        fill_in "Name", with: Faker::Lorem.characters(12) 
        fill_in "Age", with: "1"
        fill_in "Nicknames", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
      end
    end
    
    it "unlinks characters if name changes" do
      e = create :event, details: "@[#{@char.name}]"
      visit character_path @char
      expect(page).to have_content e.summary
      within "h1" do
        click_on "Edit"
      end
      fill_in "Name", with: "Something Else"
      click_on "Save"
      
      expect(page).to_not have_content e.summary
    end
    
    it "unlinks characters if nickname changes" do
      e = create :event, details: "@[#{@char.aliases.first.name}]"
      visit character_path @char
      expect(page).to have_content e.summary
      within "h1" do
        click_on "Edit"
      end
      fill_in "Nicknames", with: "Something Else"
      click_on "Save"
      
      expect(page).to_not have_content e.summary
    end
    
    describe "biography" do
      before :each do
        @events = create_list :event, 4, details: "@[#{@char.name}]"
        visit character_path @char
      end
      
      it "Shows all the events that happened relevant to the character" do
        @events.each do |e|
          expect(page).to have_content e.summary
        end
      end
    end
  end
  
end
