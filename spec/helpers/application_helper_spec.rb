require 'spec_helper'
require 'rails_helper'

describe ApplicationHelper do
  it 'nav_link returns empty class for non-selected tab' do
    link = helper.nav_link('Logout', destroy_user_session_path, :delete)
    
    expect(link).to eq("<li class=\"\"><a rel=\"nofollow\" data-method=\"delete\" href=\"/users/sign_out\">Logout</a></li>")
  end

  it 'nav_link returns empty class for non-selected tab' do
    link = helper.nav_link 'Login', new_user_session_path  
    
    expect(link).to eq("<li class=\"\"><a href=\"/users/sign_in\">Login</a></li>")
  end
  
end