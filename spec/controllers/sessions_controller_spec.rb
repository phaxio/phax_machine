require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	describe 'visiting the login page' do
    let(:action) { get :new }

    it 'renders the manage users page' do
      action
      expect(response).to be_ok
    end

    xit 'redirects to the user index page if already logged in' do
    	session[:user_id] = 1
    	action
    	expect(response).to redirect_to('/users')
    end
  end

  describe 'creating a new session (logging in)' do
  	let(:user) { create :user }
  	let(:action) {post :create, params: { :login => { email: user.email, password: user.password } } }

  	it 'logs the user in and redirects the user to the users index page' do
  		action
  		expect(flash.notice).to eq("You've been logged in as #{user.email}")
  		expect(response).to redirect_to("/users")
  	end
  end

  describe 'destroying a session (logging out)' do
  	let(:user) { create :user }
  	let(:action) {post :create, params: { :login => { email: user.email, password: user.password } } }

  	it 'logs the user out and redirects to the users index page' do
  		action
  		post :destroy
  		expect(flash.notice).to eq("You have been logged out.")
  		expect(response).to redirect_to("/users")
  	end
  end

end