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
  
  it 'should handle success flash' do
    result = helper.bootstrap_class_for('success')
    
    expect(result).to eq('alert-success')
  end
  
  it 'should handle error flash' do
    result = helper.bootstrap_class_for('error')
    
    expect(result).to eq('alert-danger')
  end

  it 'should handle alert flash' do
    result = helper.bootstrap_class_for('alert')
    
    expect(result).to eq('alert-warning')
  end

  it 'should handle notice flash' do
    result = helper.bootstrap_class_for('notice')
    
    expect(result).to eq('alert-info')
  end
  
  it 'should handle unknown flash' do
    result = helper.bootstrap_class_for('unknown')
    
    expect(result).to eq('unknown')
  end
  
end