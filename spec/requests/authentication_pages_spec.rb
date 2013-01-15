require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before{ visit signin_path }

    it { should have_selector('h1',     text: 'Sign in' ) }
    it { should have_title('Sign in') }
    it { should_not have_link('Users') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
    it { should_not have_link('Sign out') }

  end

  describe "signin" do
    before{ visit signin_path }

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin( user ) }
      it { should have_title( user.name ) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }


      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link "Sign in"}
        it { should have_alert(:notice, "logged out") }
      end
    end

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title( 'Sign in' ) }
      it { should have_alert( :error, 'Invalid' ) }

      describe "after visiting another page" do
        before{ visit root_path }
        it { should_not have_error_message }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user){ FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before{ visit edit_user_path( user ) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the users index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
      describe "in the Microposts controller" do
        describe "submitting to the microposts create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end
        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user){ FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email:"wrong@example.com") }
      let!(:micropost) { FactoryGirl.create(:micropost, user: wrong_user) }
      before { valid_signin user }

      describe "visiting Users#edit page" do
        before{ visit edit_user_path( wrong_user) }
        it { should_not have_title('Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before{ put user_path( wrong_user ) }
        specify{ response.should redirect_to root_path }
      end

      describe "submitting a DELETE request to the Micropost#destroy action" do
        before { delete micropost_path( micropost) }
        specify { response.should redirect_to(root_path) }
      end

      describe "visiting a different users profile page" do
        before { visit user_path(wrong_user) }
        it { should have_selector('span.content', text: micropost.content) }
        it { should_not have_link('delete', href: micropost_path(micropost)) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { valid_signin non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to root_path }
      end

      describe "submitting a POST request to the Users#create action" do
        before{ post users_path }
        specify{ response.should redirect_to root_path }
      end

      describe "visiting the signup page" do
        before { visit signup_path }
        it "should redirect to the homepage" do
          current_path.should == root_path
        end
      end
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before{ valid_signin admin }

      describe "attempting to delete himself" do
        before { delete user_path( admin ) }
        specify { response.should redirect_to root_path }
      end
    end
  end
end
