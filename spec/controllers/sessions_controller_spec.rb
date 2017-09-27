require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	describe 'visiting the login page' do
		let(:user) { create :user }
    let(:action) { get :new }

    it 'renders the login page' do
      action
      expect(response).to be_ok
    end

    it 'redirects to the user index page if a user is already logged in' do
    	session[:user_id] = user.id
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

  	it 'redirects to the users index page if a user is already logged in' do
  		session[:user_id] = user.id
  		action
  		expect(flash.notice).to eq("You're already logged in as #{user.email}.")
  		expect(response).to redirect_to('/users')
  	end

  	it 'redirects to the login page if invalid input is provided' do
  		user.save
  		post :create, params: { :login => { email: user.email, password: "nopenope" } }
      expect(flash.notice).to eq("Login failed.")
  		expect(response).to redirect_to('/login')
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