require 'spec_helper'

describe "Static pages" do

  subject{ page }

  shared_examples_for "all static pages" do
    it { should have_selector( 'h1', text: heading ) }
    it { should have_selector( 'title', text: full_title( page_title ) ) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_title 'About Us'
    click_link "Help"
    page.should have_title 'Help'
    click_link "Contact"
    page.should have_title 'Contact'
    click_link "Home"
    click_link "Sign up now!"
    page.should have_title 'Sign up'
    click_link "sample app"
    page.should have_title ''
  end

  describe "Home page" do
    before { visit root_path }
    let( :heading ) { 'Sample App' }
    let( :page_title ) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector( 'title', text: '| Home' ) }

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do | item |
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "the sidebar micropost count" do
        it { should have_selector("span", text: "#{user.microposts.count} microposts") }

        describe "after deleting a micropost" do
          before { click_link 'delete' }
          specify "user should have one micropost" do
            user.microposts.count.should == 1
          end
          it { should have_selector("span", text: "1 micropost") }
        end

        describe "after adding a micropost" do
          before do
            fill_in 'micropost_content', with: "some content"
            click_button "Post"
          end

          specify "user should have three microposts" do
            user.microposts.count.should == 3
          end

          it { should have_selector("span", text: "3 microposts") }
        end
      end

      describe "feed pagination" do
        before(:all) do
          35.times { FactoryGirl.create(:micropost, user: user,
                                        content: random_letters(10)) }
        end
        after(:all) { user.microposts.delete_all }

        it { should have_selector('div.pagination') }

        it "should display the first page of microposts" do
          user.microposts.paginate(page: 1).each do |micropost|
            page.should have_selector('span.content', text: micropost.content)
          end
        end

        it "should not list the second page of microposts" do 
          user.microposts.paginate(page: 2).each do |micropost|
            page.should_not have_selector('span.content',
                                          text: micropost.content)
          end
        end
      end
    end
  end

  describe "Contact page" do
    before { visit contact_path }
    let( :heading ) { 'Contact' }
    let( :page_title ) { 'Contact' }

    it_should_behave_like "all static pages"
  end


  describe "Help page" do
    before{ visit help_path }
    let( :heading ) { 'Help' }
    let( :page_title ) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before{ visit about_path }
    let( :heading ) { 'About Us' }
    let( :page_title ) { 'About' }

    it_should_behave_like "all static pages"
  end
end
