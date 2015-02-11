require 'rails_helper'

describe "Worlds" do
  before :each do
    @user = create :user
    @user.confirm!
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on "Log in"
  end
  describe "CRU" do
    it "creates" do
      visit worlds_path
      click_on "New World"
      
      n = Faker::Lorem.characters(12)
      d = Faker::Lorem.characters(12)
      
      fill_in "Name", with: n
      fill_in "Description", with: d
      click_on "Save"
      
      expect(page).to have_content n
      expect(page).to have_content d
    end
    
    it "updates" do
      w = create :world, user: @user
      visit worlds_path
      click_on "Edit Description"
      
      n = Faker::Lorem.characters(12)
      d = Faker::Lorem.characters(12)
      
      fill_in "Name", with: n
      fill_in "Description", with: d
      click_on "Save"
      
      expect(page).to have_content n
      expect(page).to have_content d
    end
    
    #it "destroys" do
    #  w = create :world, user: @user
    #  visit worlds_path
    #  click_on "Destroy"
    #  
    #  expect(page).to_not have_content w.name
    #end
  end
  
  describe "scope", :js => true do
    before :each do
      @w1 = create :world, user: @user
      @w2 = create :world, user: @user
      create :start_event, world: @w1
      create :start_event, world: @w2
    end
    
    describe "events" do
      before :each do
        @e1 = create_list :event, 3, world: @w1
        @e2 = create_list :event, 3, world: @w2
        visit worlds_path
        within "#w_#{@w2.token}" do
          click_on "Show"
        end
      end
      
      it "shows events only in that world" do
        @e2.each do |e|
          expect(page).to have_content e.summary
        end
        @e1.each do |e|
          expect(page).to_not have_content e.summary
        end
      end
      
      it "creates event in that world" do
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
    end
    
    describe "characters" do
      before :each do
        @c1 = create_list :character, 3, world: @w1
        @c2 = create_list :character, 3, world: @w2
        visit worlds_path
        within "#w_#{@w2.token}" do
          click_on "Show"
        end
      end
      
      it "shows characters only in that world" do
        within "#sidenav" do
          click_on "Characters"
        end
        @c2.each do |c|
          expect(page).to have_content c.name
        end
        @c1.each do |c|
          expect(page).to_not have_content c.name
        end
      end
      
      it "parses for only characters in that world" do
        e = create :event, details: "@[#{@c1.first.name}] @[#{@c2.first.name}]", world: @w2
        visit worlds_path
        within "#w_#{@w2.token}" do
          click_on "Show"
        end
        
        #within "#e_#{e.id}" do
        expect(page).to have_content @c1.first.name
        click_on @c1.first.name
          #end
        save_screenshot("/Users/yeeeeeeeee/Documents/plotter_uhhhhh.png", full: true)
        expect(page).to have_content "New character"
      end
    end
    
    it "shows tags only in that world" do
      @t1 = create_list :tag, 3, world: @w1
      @t2 = create_list :tag, 3, world: @w2
      visit worlds_path
      within "#w_#{@w2.token}" do
        click_on "Show"
      end
      within "#sidenav" do
        click_on "Tags"
      end
      @t2.each do |t|
        expect(page).to have_content t.content
      end
      @t1.each do |t|
        expect(page).to_not have_content t.content
    
      end
    end
  end
  
  describe "settings", js: true do
    before :each do
      @world = create :world, user: @user
      @start_event = create :start_event, world: @world
      @events = create_list :event, 3, world: @world, happened_on: "2014-01-01"
      @other_events = create_list :event, 3, world: @world, happened_on: "2013-01-01"
      visit world_settings_path(@world)
    end
    
    it "changes events to relative" do
      uncheck "world_is_absolute"
      click_on "Save"
      
      (@events + @other_events).each do |e|
        expect(page).to have_content e.summary
        expect(page).to_not have_content e.happened_on
      end
    end
    
    it "defaults the view to months" do
      select "Months", from: "world_scale"
      click_on "Save"
      
      @events.each do |e|
        expect(page).to have_content e.summary
      end
      @other_events.each do |e|
        expect(page).to_not have_content e.summary
      end
    end
  end
  
  describe "collaboration", js: true do
    it "lets not logged in users view public worlds" do
      world = create :world, is_public: true
      click_on "Log Out"
      visit world_events_path world
      expect(page).to have_content world.name
    end
    
    it "does not let unpermitted users to view" do
      world = create :world
      visit world_events_path world
      expect(page).to have_content "Sorry. We couldn't find that world and its related content."
    end
    
    it "does not let unpermitted users to edit event" do
      world = create :world
      ruling = create :ruling, world: world, user: @user, role: "view"
      create :start_event, world: world
      e = create :event, world: world
      visit world_events_path(world)
    
      within "#e_#{e.id}" do
        expect(page).to_not have_content "Edit"
        expect(page).to_not have_content "Remove"
      end
    end
    
    it "does not let unpermitted users to edit character" do
      world = create :world
      ruling = create :ruling, world: world, user: @user, role: "view"
      char = create :character, world: world
      visit edit_world_character_path(world,char)
      expect(page).to have_content "Sorry. You don't have permission to do that."
    end
    
    it "does not let unpermitted users to add collaborators" do
      world = create :world
      ruling = create :ruling, world: world, user: @user, role: "write"
      visit world_rulings_path(world)
      expect(page).to have_content "Sorry. You don't have permission to do that."
    end
    
    it "creates collaborators" do
      user2 = create :user, email: "#{Faker::Lorem.characters(12)}@a.com"
      world = create :world, user: @user
      
      visit world_rulings_path world
      fill_in "ruling[email]", with: user2.email
      click_on "Add New Collaborator"
      
      visit world_rulings_path world
      expect(page).to have_content user2.name
      expect(page).to have_content user2.email
    end
    
    it "deletes collaborators" do
      user2 = create :user, email: "#{Faker::Lorem.characters(12)}@a.com"
      world = create :world, user: @user
      r = create :ruling, user: user2, world: world
      
      visit world_rulings_path world
      save_screenshot("/Users/yeeeeeeeee/Documents/plotter.png", full: true)
      #within "#tr_#{r.id}" do
        click_on "Remove User"
        #end
      visit world_rulings_path world
      expect(page).to_not have_content user2.email
      
    end
    it "adds collaborators who are not yet registered" do
      email = "#{Faker::Lorem.characters(12)}@a.com"
      world = create :world, user: @user
      
      visit world_rulings_path world
      fill_in "ruling[email]", with: email
      click_on "Add New Collaborator"
      
      visit world_rulings_path world
      expect(page).to have_content "Not yet signed up"
      expect(page).to have_content email
      
      click_on "Log Out"
      user2 = create :user, email: email
      user2.confirm!
      visit new_user_session_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: "12345678"
      click_on "Log in"
      expect(page).to have_content world.name
    end
  end
end
