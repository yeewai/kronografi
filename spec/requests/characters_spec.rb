require 'rails_helper'

describe "Characters", js: true do
  before :each do
    @user = create :user
    @user.confirm!
    @world = create :world, user: @user
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on "Log in"
  end
  
  it "creates new characters" do
    visit new_world_character_path(@world)
    
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
    create :character, name: n, world: @world
    visit new_world_character_path(@world)

    fill_in "Age", with: 1
    fill_in "Nicknames", with: n
    expect(page).to have_button('Save', disabled: true)
  end
  
  it "doesn't let you use nonunique nicknames" do
    n = Faker::Lorem.characters(12)
    create :alias, name: n, world: @world
    visit new_world_character_path @world

    fill_in "Age", with: 1
    fill_in "Nicknames", with: n
    expect(page).to have_button('Save', disabled: true)
  end
  
  it "edits characters" do
    @char = create :character, world: @world
    visit world_character_path(@world, @char)
    click_on "Edit Info"
    
    age = Faker::Number.number(1)

    fill_in "Age", with: age
    
    click_on "Save"
    
    expect(page).to have_content age
  end
  
  describe "linking to events" do
    before :each do
      @start_event = create :start_event, world: @world
      @char = create :character, world: @world
      @event = create :event, world: @world
      visit world_events_path(@world)

      save_screenshot("/Users/yeeeeeeeee/Documents/plotter_beforee.png")
      within "#e_#{@event.id}" do
        click_link "Edit"
      end
      save_screenshot("/Users/yeeeeeeeee/Documents/plotter_aftere.png")
    end
    
    it "links to events by mentioning character name in the details" do
      #within "#edit_event_modal" do
      #  #within_frame "event_details_#{@event.id}_ifr" do
      #    find("[data-id='event_details_#{@event.id}']").set("@[#{@char.name}]")
      #    #fill_in "event_details_#{@event.id}", :with =>"@[#{@char.name}]"
      #    #end  
      #  click_on "Save Event"
      #end
      @event.details = "@[#{@char.name}]"
      @event.save!
      
      visit world_character_path(@world, @char)
      within "#e_#{@event.id} .char_list" do
        expect(page).to have_content @char.name
      end
    end
    
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
        e = create :event, details: "@[#{n}]", world: @world
        visit new_world_character_path(@world)

        fill_in "Age", with: "1"
        fill_in "Name", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
        
      end
      
      it "links to event if matching case insensitive name is found" do
        n = Faker::Lorem.characters(12) 
        e = create :event, details: "@[#{n.downcase}]", world: @world
        visit new_world_character_path(@world)

        fill_in "Age", with: "1"
        fill_in "Name", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
        
      end
      
      it "links to event if matching nickname is found" do
        n = Faker::Lorem.characters(12) 
        e = create :event, details: "@[#{n}]", world: @world
        visit new_world_character_path(@world)
        
        fill_in "Name", with: Faker::Lorem.characters(12) 
        fill_in "Age", with: "1"
        fill_in "Nicknames", with: n
        click_on "Save"
        
        expect(page).to have_content e.summary
      end
    end
    
    describe "destroying character" do
      it "deletes character and unlinks events" do 
        @event.details = "@[#{@char.name}]"
        @event.save!
        visit world_character_path(@world, @char)
        
        click_on "Delete Character"
        within "#destroy_char_modal" do
          check "confirm"
          click_on "Delete #{@char.name}"
        end
        
        visit world_events_path(@world)
        within "#e_#{@event.id} .char_list" do
          expect(page).to_not have_content @char.name
        end
      end
      
      it "changes nicknames to name (if desired)" do
        @event.details = "@[#{@char.aliases.first.name}]"
        @event.save!
        visit world_character_path(@world, @char)
        
        click_on "Delete Character"
        within "#destroy_char_modal" do
          check "confirm"
          check "persist"
          click_on "Delete #{@char.name}"
        end
        
        visit world_events_path(@world)
        within "#e_#{@event.id}" do
          click_on "Details"
          expect(page).to have_content @char.name
        end
      end
    end
    
    describe "editing names" do
      it "changes name in events (if desired)" do
        @event.details = "@[#{@char.name}]"
        @event.save!
        visit world_character_path(@world, @char)
        
        n = Faker::Lorem.characters(12) 
        
        click_on "Change Name"
        within "#edit_name_modal" do
          fill_in "Name", with: n
          check "persist"
          click_on "Save"
        end
        
        within "#e_#{@event.id}" do
          click_on "Details"
          expect(page).to have_content n
        end
      end
      
      it "unlinks characters (if desired)" do
        @event.details = "@[#{@char.name}]"
        @event.save!
        visit world_character_path(@world, @char)
        
        n = Faker::Lorem.characters(12) 
        
        click_on "Change Name"
        within "#edit_name_modal" do
          fill_in "Name", with: n
          uncheck "persist"
          click_on "Save"
        end
        
        expect(page).to_not have_content @event.summary
      end
      
      it "changes nicknames in events (if desired)" do
        a = @char.aliases.first
        @event.details = "@[#{a.name}]"
        @event.save!
        visit world_character_path(@world, @char)
      
        n = Faker::Lorem.characters(12) 
        
        within "#a_#{a.id}" do
          click_on "Edit"
        end
        within "#edit_name_modal" do
          fill_in "Name", with: n
          check "persist"
          click_on "Save"
        end
      
        within "#e_#{@event.id}" do
          click_on "Details"
          expect(page).to have_content n
        end
      end
      
      it "unlinks characters if nickname changes (if desired)" do
        a = @char.aliases.first
        @event.details = "@[#{a.name}]"
        @event.save!
        visit world_character_path(@world, @char)
      
        n = Faker::Lorem.characters(12) 
        
        within "#a_#{a.id}" do
          click_on "Edit"
        end
        within "#edit_name_modal" do
          fill_in "Name", with: n
          uncheck "persist"
          click_on "Save"
        end
      
        expect(page).to_not have_content @event.summary
      end
      
      it "changes nickname in event to name if nickname is removed (if desired)" do
        a = @char.aliases.first
        @event.details = "@[#{a.name}]"
        @event.save!
        visit world_character_path(@world, @char)
        
        within "#a_#{a.id}" do
          click_on "Remove"
        end
        
        within "#edit_name_modal" do
          check "persist"
          click_on "Remove nickname"
        end
        
        within "#e_#{@event.id}" do
          click_on "Details"
          expect(page).to have_content @char.name
        end
      end
      
      it "adds additional nicknames" do
        visit world_character_path(@world, @char)
        click_on "+ Add nickname(s)"
        
        n1 = Faker::Lorem.characters(12)
        n2 = Faker::Lorem.characters(12)
        @event.details = "@[#{n1}]"
        @event.save!
        
        within "#new_name_modal" do
          fill_in "Nicknames", with: "#{n1}, #{n2}"
          click_on "Add nickname(s)"
        end
        
        expect(page).to have_content n1
        expect(page).to have_content n2
        
        within "#e_#{@event.id}" do
          click_on "Details"
          expect(page).to have_content n1
        end
      end
    end
    
    describe "biography" do
      before :each do
        @events = create_list :event, 4, details: "@[#{@char.name}]", world: @world
        visit world_character_path @world, @char
      end
      
      it "Shows all the events that happened relevant to the character" do
        @events.each do |e|
          expect(page).to have_content e.summary
        end
      end
    end
    
  end
  
end
