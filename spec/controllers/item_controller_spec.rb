# This whole file was originally AI generated (before Apr. 14th 16:53). 
# This file is now fully reviewed and modified by hand
require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:seller) { User.create!(name: "seller_user", email: "seller@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "Chung Chi College") }
  let(:reserver) { User.create!(name: "reserver_user", email: "reserver@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "New Asia College") }
  let(:other_user) { User.create!(name: "other_user", email: "other@link.cuhk.edu.hk", password: "password", password_confirmation: "password", location: "United College") }

  let(:valid_attributes) do
    {
      name: "Test Lamp",
      description: "A beautiful lamp",
      category: "furniture",
      price: 29.99,
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "",
      category: "",
      price: 0
    }
  end

  let!(:item) do
    Item.create!(
      name: "Test Lamp",
      description: "A beautiful lamp",
      category: "furniture",
      price: 29.99,
      seller: seller,
      post_date: Date.current,
      status: "available"
    )
  end

  before do
    # Mock current_user for actions that require authentication
    allow(controller).to receive(:current_user).and_return(seller)
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @items with search results" do
      get :index
      expect(assigns(:items)).to include(item)
    end

    it "assigns @active_quick_filters" do
      get :index, params: { quick_filters: "under_100,available_now" }
      expect(assigns(:active_quick_filters)).to eq(["under_100", "available_now"])
    end

    it "assigns @search_filters with defaults from quick filters" do
      get :index, params: { quick_filters: "under_100" }
      expect(assigns(:search_filters)[:max_price]).to eq("100")
    end

    it "assigns @favorite_item_ids when user is logged in" do
      allow(controller).to receive(:current_user).and_return(seller)
      seller.favorite_items << item
      get :index
      expect(assigns(:favorite_item_ids)).to include(item.id)
    end

    it "assigns empty @favorite_item_ids when no user is logged in" do
      allow(controller).to receive(:current_user).and_return(nil)
      get :index
      expect(assigns(:favorite_item_ids)).to eq([])
    end

    it "assigns @autocomplete_suggestions when keyword is present" do
      get :index, params: { keyword: "Lamp" }
      expect(assigns(:autocomplete_suggestions)).to include("Test Lamp")
    end

    it "assigns @autocomplete_suggestions from distinct names when no keyword" do
      get :index
      expect(assigns(:autocomplete_suggestions)).to include("Test Lamp")
    end

    it "assigns @seller_locations" do
      get :index
      expect(assigns(:seller_locations)).to eq(User::COLLEGE_LOCATIONS)
    end

    it "converts @items to array to avoid PostgreSQL count issues" do
      get :index
      expect(assigns(:items)).to be_an(Array)
    end

    context "with search parameters" do
      it "filters by keyword" do
        get :index, params: { keyword: "Lamp" }
        expect(assigns(:items)).to include(item)
      end

      it "filters by category" do
        get :index, params: { category: "furniture" }
        expect(assigns(:items)).to include(item)
      end

      it "filters by min_price" do
        get :index, params: { min_price: "20" }
        expect(assigns(:items)).to include(item)
      end

      it "filters by max_price" do
        get :index, params: { max_price: "50" }
        expect(assigns(:items)).to include(item)
      end

      it "sorts results" do
        get :index, params: { sort: "price_low_to_high" }
        expect(assigns(:items)).to include(item)
      end
    end
  end

  describe "GET #autocomplete" do
    it "returns JSON suggestions" do
      get :autocomplete, params: { q: "Lamp" }, format: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include("Test Lamp")
    end

    it "returns empty array when q is blank" do
      get :autocomplete, params: { q: "" }, format: :json
      expect(JSON.parse(response.body)).to eq([])
    end

    it "returns limited suggestions" do
      # Create more items
      10.times do |i|
        Item.create!(
          name: "Lamp #{i}",
          description: "Test",
          category: "furniture",
          price: 10,
          seller: seller,
          post_date: Date.current,
          status: "available"
        )
      end
      get :autocomplete, params: { q: "Lamp" }, format: :json
      expect(JSON.parse(response.body).size).to be <= 8
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: item.id }
      expect(response).to be_successful
    end

    it "assigns @item" do
      get :show, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end

    it "assigns @user" do
      get :show, params: { id: item.id }
      expect(assigns(:user)).to eq(seller)
    end

    it "returns 404 for non-existent item" do
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

    it "assigns a new item" do
      get :new
      expect(assigns(:item)).to be_a_new(Item)
    end

    it "assigns @user" do
      get :new
      expect(assigns(:user)).to eq(seller)
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: item.id }
      expect(response).to be_successful
    end

    it "assigns the requested item" do
      get :edit, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new item" do
        expect {
          post :create, params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it "sets post_date to current date" do
        post :create, params: { item: valid_attributes }
        new_item = Item.last
        expect(new_item.post_date).to eq(Date.current.to_s)
      end

      it "sets seller to current_user" do
        post :create, params: { item: valid_attributes }
        new_item = Item.last
        expect(new_item.seller).to eq(seller)
      end

      it "sets status to available" do
        post :create, params: { item: valid_attributes }
        new_item = Item.last
        expect(new_item.status).to eq("available")
      end

      it "redirects to the created item" do
        post :create, params: { item: valid_attributes }
        expect(response).to redirect_to(Item.last)
      end

      it "sets a success notice" do
        post :create, params: { item: valid_attributes }
        expect(flash[:notice]).to eq("Item was successfully posted!")
      end
    end

    context "with invalid parameters" do
      it "does not create a new item" do
        expect {
          post :create, params: { item: invalid_attributes }
        }.not_to change(Item, :count)
      end

      it "renders the new template" do
        post :create, params: { item: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it "returns unprocessable entity status" do
        post :create, params: { item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #purchase" do
    it "updates item status to sold" do
      patch :purchase, params: { id: item.id }, format: :turbo_stream
      item.reload
      expect(item.status).to eq("sold")
    end

    it "redirects to item with html format" do
      patch :purchase, params: { id: item.id }, format: :html
      expect(response).to redirect_to(item)
    end

    it "returns 404 for non-existent item" do
      expect {
        patch :purchase, params: { id: 99999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "PATCH #reserve" do
    it "updates item status to reserved" do
      patch :reserve, params: { id: item.id }, format: :turbo_stream
      item.reload
      expect(item.status).to eq("reserved")
    end

    it "sets reserver to current_user" do
      patch :reserve, params: { id: item.id }, format: :turbo_stream
      item.reload
      expect(item.reserver).to eq(seller)
    end

    it "redirects to item with html format" do
      patch :reserve, params: { id: item.id }, format: :html
      expect(response).to redirect_to(item)
    end

    it "returns 404 for non-existent item" do
      expect {
        patch :reserve, params: { id: 99999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "private methods" do
    describe "#set_item" do
      it "finds the correct item" do
        get :show, params: { id: item.id }
        expect(assigns(:item)).to eq(item)
      end
    end

    describe "#set_user" do
      it "assigns @user to current_user" do
        get :index
        expect(assigns(:user)).to eq(seller)
      end
    end

    describe "#effective_search_filters" do
      it "merges quick filter defaults" do
        get :index, params: { quick_filters: "under_100", max_price: "" }
        expect(assigns(:search_filters)[:max_price]).to eq("100")
      end

      it "does not override explicitly provided filters" do
        get :index, params: { quick_filters: "under_100", max_price: "200" }
        expect(assigns(:search_filters)[:max_price]).to eq("200")
      end

      it "excludes quick_filters from search filters" do
        get :index, params: { quick_filters: "under_100" }
        expect(assigns(:search_filters).keys).not_to include(:quick_filters)
      end
    end

    describe "#selected_quick_filters" do
      it "splits comma-separated quick_filters" do
        get :index, params: { quick_filters: "under_100,available_now,books_notes" }
        expect(assigns(:active_quick_filters)).to eq(["under_100", "available_now", "books_notes"])
      end

      it "strips whitespace and removes blanks" do
        get :index, params: { quick_filters: "under_100, ,available_now,," }
        expect(assigns(:active_quick_filters)).to eq(["under_100", "available_now"])
      end

      it "returns empty array when quick_filters is blank" do
        get :index, params: { quick_filters: "" }
        expect(assigns(:active_quick_filters)).to eq([])
      end
    end

    describe "#quick_filter_defaults" do
      it "returns merged filters for multiple quick filters" do
        get :index, params: { quick_filters: "under_100,available_now" }
        # Check via search_filters which uses quick_filter_defaults
        expect(assigns(:search_filters)[:max_price]).to eq("100")
        expect(assigns(:search_filters)[:status]).to eq("available")
      end

      it "returns empty hash for unknown filter" do
        get :index, params: { quick_filters: "unknown_filter" }
        expect(assigns(:search_filters)[:max_price]).to be_nil
      end
    end
  end
end