require 'rails_helper'

describe "User", :js => true do
  before :each do
    @user = create :user
    @user.confirm!
    @world = create :world, user: @user
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "12345678"
    click_on "Log in"
  end
  
  it "only shows users worlds" do
    @other_worlds = create_list :world, 3
    visit worlds_path
    
    expect(page).to have_content @world.name
    @other_worlds.each do |w|
      expect(page).to_not have_content w.name
    end
  end
  
  it "does not let users view worlds over which they have no jurisdiction" do
    @other_world = create :world
    
    visit world_events_path(@other_world)
    expect(page).to have_content "Sorry. We couldn't find that world"
  end
end
