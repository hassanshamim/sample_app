include ApplicationHelper

def valid_signin( user )
  visit signin_path
  fill_in "Email",     with: user.email
  fill_in "Password",  with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well
  cookies[:remember_token] = user.remember_token
end

def valid_signup 
  fill_in "Name",         with: "Example_User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end

def random_letters(n)
  ('a'..'z').to_a.sample(n).join
end
