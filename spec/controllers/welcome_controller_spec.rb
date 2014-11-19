require 'rails_helper'

describe WelcomeController, :type => :controller do

  it "GET index returns http success" do
    get :index
    expect(response).to be_success
  end

end
