class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit ]
  before_action :set_user, only: %i[ index show new edit ]

  def index
    @active_quick_filters = selected_quick_filters
    @search_filters = effective_search_filters
    @favorite_item_ids = current_user.present? ? current_user.favorite_items.ids : []

    # 先把查询结果加载成数组，避免视图里 count/size 对带 search_rank
    # 自定义 select 的 relation 再次触发 PostgreSQL 计数 SQL。
    @items = Item.search(@search_filters).to_a
    @autocomplete_suggestions = if @search_filters[:keyword].present?
      Item.autocomplete(@search_filters[:keyword], limit: 8)
    else
      Item.where.not(name: [ nil, "" ]).distinct.order(:name).limit(8).pluck(:name)
    end
    @seller_locations = Item.available_seller_locations
  end

  def autocomplete
    suggestions = Item.autocomplete(params[:q])

    render json: suggestions
  end

  def show
    @item.increment!(:views)
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    new_item_params = item_params()

    @item = Item.new(new_item_params)
    @item.post_date = Date.current
    @item.seller = current_user
    @item.status = "available"

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

    def set_user
      @user = current_user
    end

    def item_params
      params.require(:item).permit(:name, :category, :description, :price, :seller_name, :photo)
    end

    def search_params
      params.permit(:keyword, :category, :status, :seller_location, :min_price, :max_price, :posted_within_days, :sort, :quick_filters)
    end

    def effective_search_filters
      filters = search_params.to_h.symbolize_keys.except(:quick_filters)

      quick_filter_defaults.each do |key, value|
        filters[key] = value if filters[key].blank?
      end

      filters
    end

    def selected_quick_filters
      search_params[:quick_filters].to_s.split(",").map(&:strip).reject(&:blank?).uniq
    end

    def quick_filter_defaults
      selected_quick_filters.each_with_object({}) do |filter_id, merged_filters|
        merged_filters.merge!(quick_filter_config[filter_id] || {})
      end
    end

    def quick_filter_config
      {
        "under_100" => { max_price: "100" },
        "available_now" => { status: "available" },
        "books_notes" => { category: "books" }
      }
    end
end
