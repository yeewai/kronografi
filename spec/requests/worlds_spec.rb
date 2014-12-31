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
      click_on "Edit"
      
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
        
        within "#e_#{e.id}" do
          expect(page).to_not have_content @c1.first.name
          expect(page).to have_content @c2.first.name
        end
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
end
