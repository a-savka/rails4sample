require 'spec_helper'

describe "Static pages" do

  describe "Hone page" do
    it "should have the content 'Sample App'" do
    	visit '/static_pages/home'
    	expect(page).to have_content('Sample App')
    end

    it "should have the title 'Home'" do
    	visit '/static_pages/home'
    	expect(page).to have_title("Ruby on Rails tutorial sample app | Home")
    end
  end

  describe "Help page" do
  	it "should have the content 'help'" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  	end

  	it "should have the title 'Help'" do
  		visit '/static_pages/help'
  		expect(page).to have_title("Ruby on Rails tutorial sample app | Help")
  	end  	
  end

  describe "About page" do
  	it "should have the content 'About Us'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end

  	it "should have the title 'About Us'" do
  		visit '/static_pages/about'
  		expect(page).to have_title('Ruby on Rails tutorial sample app | About Us')
  	end
  end

end
