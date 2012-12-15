require 'spec_helper'


describe "Static pages" do
  let( :base_title ){ "Ruby on Rails Tutorial Sample App |" }

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      page.should have_content('Contact')
    end

    it "should have the right title" do
      visit '/static_pages/contact'
      page.should have_selector('title', :text => "#{base_title} Contact" )
    end
  end

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      page.should have_selector('title',
                        :text => "Ruby on Rails Tutorial Sample App")
    end

    it "should not have the custom page title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', :text => " | Home" )
    end
  end

  describe "Help page" do

    it "should have content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "#{base_title} Help" )
    end
  end

  describe "About page" do

    it "should have content 'About'" do
      visit '/static_pages/about'
      page.should have_content('About')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "#{base_title} About" )
    end
  end
end
