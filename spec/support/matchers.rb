
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

Rspec::Matchers.define :have_alert do | alert_type, message = nil |
  match do | page |
    page.should have_selector("div.alert.alert-#{alert_type}", text: message )
  end
end

RSpec::Matchers.define :have_title do | title_text |
  match do |page|
    page.should have_selector 'title', text: full_title( title_text )
  end
end

RSpec::Matchers.define :have_error_explainations do | error_list |
  match do |page|
    error_list.each {|e| error_item( e ) }
  end

  def error_item( explaination )
    page.should have_selector('div#error_explanation ul li', text: explaination )
  end
end

