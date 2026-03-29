class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit ]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    new_item_params = item_params()
    name = new_item_params[:seller_name]
    new_item_params.delete(:seller_name)

    @item = Item.new(new_item_params)
    @item.post_date = Date.current
    @item.seller_id = User.find_seller_id(name)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully posted!" }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :category, :description, :price, :seller_name, :photo)
    end
end
