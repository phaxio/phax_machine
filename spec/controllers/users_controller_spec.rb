require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'visiting the manage users page' do
    let(:action) { get :index }

    it 'renders the manage users page' do
      user = create :user
      action
      expect(response).to be_ok
      assert_select('.page_title', text: 'Manage Users')
      assert_select('.users-table') do
        assert_select('td', text: user.email)
        assert_select('td', text: user.fax_number)
      end
    end
  end

  describe 'viewing a user' do
    let(:user) { create :user }
    let(:action) { get :show, params: params, format: expected_format }

    describe 'visiting the show user page' do
      let(:expected_format) { 'html' }
      let(:params) { {id: user} }

      it 'renders the user show page' do
        action
        expect(response).to be_ok
        assert_select '.page_title', text: "Viewing #{user.email}"
      end
    end

    describe 'getting user data' do
      let(:expected_format) { 'json' }

      describe 'by default' do
        let(:params) { {id: user} }

        it 'returns the user data retrieved from phaxio' do
          expect(Phaxio).to receive(:list_faxes).with(number: user.fax_number) do
            {
              'success' => true,
              'message' => 'Retrieved faxes successfully'
            }
          end

          action
          expect(response).to be_ok
          response_data = JSON.parse(response.body)
          expect(response_data['success']).to eq(true)
          expect(response_data['message']).to eq('Retrieved faxes successfully')
        end
      end

      describe 'with a custom date range' do
        let(:start_time) { 1.week.ago.to_i }
        let(:end_time) { DateTime.current.to_i }

        let(:params) { {id: user, start: start_time, end: end_time} }

        it 'allows specifying a custom date range' do
          expected_options = {
            number: user.fax_number,
            start: start_time,
            end: end_time
          }
          expect(Phaxio).to receive(:list_faxes).with(expected_options) do
            {
              'success' => true,
              'message' => 'Retrieved faxes successfully'
            }
          end

          action
          expect(response).to be_ok
        end
      end
    end
  end

  describe 'visiting the add user page' do
    let(:action) { get :new }

    it 'renders the new user page' do
      action
      expect(response).to be_ok
      assert_select('.page_title', text: 'Add User')
      assert_select('form.new_user')
    end
  end

  describe 'adding a user' do
    let(:action) { post :create, params: params }

    context 'valid' do
      let(:params) { {user: attributes_for(:user)} }

      it 'creates the user' do
        expect { action }.to change(User, :count).by(1)
      end

      it 'sets the success message' do
        action
        expect(flash.notice).to eq('User added successfully.')
      end

      it 'redirects to the manage users page' do
        action
        expect(response).to redirect_to(users_path)
      end
    end

    context 'invalid' do
      let(:params) { {user: attributes_for(:user, fax_number: '')} }

      it 'renders the new template' do
        action
        expect(response).to be_ok
        assert_select '.page_title', text: 'Add User'
      end
    end
  end

  describe 'visiting the edit user page' do
    let(:user) { create :user }
    let(:action) { get :edit, params: {id: user} }

    it 'renders the edit user page' do
      action
      expect(response).to be_ok
      assert_select '.page_title', text: 'Edit User'
      assert_select "form#edit_user_#{user.id}"
    end
  end

  describe 'updating a user' do
    let!(:user) { create :user }
    let(:action) { patch :update, params: params }

    context 'valid' do
      let(:params) { {id: user.id, user: attributes_for(:user)} }

      it 'updates the user' do
        expect do
          action
          user.reload
        end.to change(user, :email)
      end

      it 'sets the success message' do
        action
        expect(flash.notice).to eq('User updated successfully.')
      end

      it 'redirects to the manage users page' do
        action
        expect(response).to redirect_to(users_path)
      end
    end

    context 'invalid' do
      let(:params) { {id: user.id, user: attributes_for(:user, email: 'invalid')} }

      it 'renders the edit template' do
        action
        expect(response).to be_ok
        assert_select '.page_title', text: 'Edit User'
      end
    end
  end

  describe 'deleting a user' do
    let!(:user) { create :user }
    let(:action) { delete :destroy, params: {id: user} }

    it 'deletes the user' do
      action
      expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'sets the success message' do
      action
      expect(flash.notice).to eq('User deleted successfully.')
    end

    it 'redirects to the manage users page' do
      action
      expect(response).to redirect_to(users_path)
    end
  end
end
