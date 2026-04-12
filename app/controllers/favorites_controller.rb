class FavoritesController < ApplicationController
  before_action :require_login

  def index
    @favorite_items = current_user.favorite_items
  end

  def create
    @item = Item.find(params[:item_id])
    current_user.favorites.find_or_create_by(item: @item)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          view_context.dom_id(@item, :favorite_toggle),
          partial: "items/favorite_toggle",
          locals: { item: @item, favorited: true }
        )
      end
      format.html { redirect_to request.referer || @item }
    end
  end

  def destroy
    @item = Item.find(params[:id])
    favorite = current_user.favorites.find_by(item_id: params[:id])
    favorite&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          view_context.dom_id(@item, :favorite_toggle),
          partial: "items/favorite_toggle",
          locals: { item: @item, favorited: false }
        )
      end
      format.html { redirect_to request.referer || items_path }
    end
  end
end
