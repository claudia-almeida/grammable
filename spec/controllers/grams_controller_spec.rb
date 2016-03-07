require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully show the new form" do
      user = User.create(
        email: 'ihavenids@gmail.com',
        password: '123456789',
        password_confirmation: '123456789'
      )
      sign_in user

      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, gram: { message: "Hello" }
      expect(response).to redirect_to new_user_session_path
    end

    it "Should successfully create a new gram in the database" do
      user = User.create(
        email: 'ihavenids@gmail.com',
        password: '123456789',
        password_confirmation: '123456789'
      )
      sign_in user

      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validations" do
      user = User.create(
        email: 'ihavenids@gmail.com',
        password: '123456789',
        password_confirmation: '123456789'
      )
      sign_in user

      gram_count = Gram.count
      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end

  end

end