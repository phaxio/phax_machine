require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'OK'
    end
  end

  describe 'requiring authentication' do
    it 'executes the action with the correct username and password' do
      get :index
      expect(response).to be_ok
      expect(response.body.strip).to eq('OK')
    end

    it 'returns a 401 Not Authorized response with incorrect credentials' do
      set_basic_auth 'wrong', 'wrong again'
      get :index
      expect(response.status).to eq(401)
    end
  end
end
