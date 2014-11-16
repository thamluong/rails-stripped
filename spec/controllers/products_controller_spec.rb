require 'rails_helper'

RSpec.describe ProductsController, :type => :controller do

  it "returns http success for show action" do
    get :show
  
    expect(response).to be_success
  end

  it "returns http success for download action" do
    get :download
  
    expect(response).to be_success
  end
  
end
