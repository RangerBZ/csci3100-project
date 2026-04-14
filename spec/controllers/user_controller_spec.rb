# This whole file was originally AI generated (before Apr. 14th 16:53). 
# This file is now fully reviewed and modified by hand
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      name: "testuser",
      email: "testuser@link.cuhk.edu.hk",
      password: "password",
      password_confirmation: "password",
      location: "Chung Chi College"
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      email: "invalid@example.com",
      password: "short",
      password_confirmation: "mismatch"
    }
  end

  let(:user) { User.create!(valid_attributes) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @users" do
      user1 = User.create!(valid_attributes)
      user2 = User.create!(valid_attributes.merge(name: "another", email: "another@link.cuhk.edu.hk"))
      get :index
      expect(assigns(:users)).to match_array([user1, user2])
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it "assigns @user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it "returns 404 for non-existent user" do
      expect {
        get :show, params: { id: 99999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end

    it "assigns the requested user" do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "sets post_date for the item" do
        post :create, params: { user: valid_attributes }
        new_user = User.last
        expect(new_user.name).to eq(valid_attributes[:name])
      end

      it "redirects to login_path" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(login_path)
      end

      it "sets a success notice" do
        post :create, params: { user: valid_attributes }
        expect(flash[:notice]).to eq("User was successfully created!")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "renders the new template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it "returns unprocessable entity status" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:update_attributes) do
        {
          name: "updatedname",
          location: "New Asia College"
        }
      end

      it "updates the requested user" do
        patch :update, params: { id: user.id, user: update_attributes }
        user.reload
        expect(user.name).to eq("updatedname")
        expect(user.location).to eq("New Asia College")
      end

      it "redirects to the user" do
        patch :update, params: { id: user.id, user: update_attributes }
        expect(response).to redirect_to(user)
      end

      it "sets a success notice" do
        patch :update, params: { id: user.id, user: update_attributes }
        expect(flash[:notice]).to eq("Profile was successfully updated.")
      end

      context "when password is blank" do
        it "does not update password" do
          original_password_digest = user.password_digest
          patch :update, params: {
            id: user.id,
            user: {
              password: "",
              password_confirmation: "",
              name: "newname"
            }
          }
          user.reload
          expect(user.password_digest).to eq(original_password_digest)
          expect(user.name).to eq("newname")
        end
      end

      context "when password is provided" do
        it "updates password" do
          patch :update, params: {
            id: user.id,
            user: {
              password: "newpassword",
              password_confirmation: "newpassword"
            }
          }
          expect(user.reload.authenticate("newpassword")).to be_truthy
        end
      end
    end

    context "with invalid parameters" do
      it "renders the edit template" do
        patch :update, params: { id: user.id, user: { name: "" } }
        expect(response).to render_template(:edit)
      end

      it "returns unprocessable entity status" do
        patch :update, params: { id: user.id, user: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end