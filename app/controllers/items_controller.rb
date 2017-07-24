class ItemsController < ApplicationController


  before_action :authenticate_user!, :except => [:index, :show]
  before_filter :ensure_admin, :only => [:edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  MIN_PLAYER = 0
  MAX_PLAYER = 1_000 # up to 1000 players
  MIN_PRICE = 0
  MAX_PRICE = 10_000 # 10_000 Euro
  
	# Sorting constants
	# sort product name by alphabetic order
	ORDER_A_TO_Z_NAME = 0
	# sort product name by inverted alphabetic order
	ORDER_Z_TO_A_NAME = 1
	# sort product price by from lowest to most expensive
	ORDER_MIN_TO_MAX_PRICE = 2
	# sort product price by from expensive to most lowest
	ORDER_MAX_TO_MIN_PRICE = 3
	
  # GET /items
  # GET /items.json
  def index

    @items = Item.all
    @designer = Designer.all

	  where_sql, where_variables, secure_order = search_query_information

    #puts "where_sql : " + where_sql
    #puts "where_variables :" + where_variables.to_s
    #puts "secure_order :" + secure_order.to_s
	  
    @items = Item.where(where_sql, where_variables).order(secure_order)
  end
  
  def home
    # newest product 
    # offers (price != msrp)
    # (best sellers => order.qty)
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def ensure_admin
    unless current_user.try(:admin?)
      render :text => "Access Error Message", :status => :unauthorized
    end
  end

  private
    # sanatize the search parameters, return an SQL 
    def search_query_information
  
  
      where_sql = ""
      where_variables = {}
      secure_order = nil
  
      # build the where statement by checking each values in params
      
      if params[:keywords].present? and !params[:keywords].gsub(/[^0-9a-z\ ]/i, '').strip.empty?
        where_sql += ' name LIKE :keywords OR description LIKE :keywords '
        where_variables[:keywords] =  "%#{ params[:keywords].gsub(/[^0-9a-z\ ]/i, '').strip }%" 
      end     
  
  
      if params[:category_id].present? and Category.find_by_id(params[:category_id].to_i).present?
        where_sql += (where_sql == '' ? '' : ' and ') + ' category = :category '
        where_variables[:category] =  params[:category_id].to_i
      end     
  
      if params[:min_price].present? and (params[:min_price].to_i >= 0)
        min_price = params[:min_price].to_i
      else
        min_price = nil
      end
      
      if params[:max_price].present? and (params[:max_price].to_i >= 0)
        max_price = params[:max_price].to_i
      else
        max_price = nil
      end    
      
      if min_price.nil? and max_price.nil?
        # do nothing
      elsif max_price.nil?
        where_sql += (where_sql == '' ? '' : ' and ') + ' price <= :min_price '
        where_variables[:min_price] =  min_price
      elsif min_price.nil?
        where_sql += (where_sql == '' ? '' : ' and ') + ' price >= :max_price '
        where_variables[:max_price] =  max_price
      else
        where_sql += (where_sql == '' ? '' : ' and ') + ' price between :min_price and :max_price '
        where_variables[:min_price] =  min_price
        where_variables[:max_price] =  max_price
      end
  
  
      if params[:min_player].present? and (params[:min_player].to_i >= 0)
        where_sql += (where_sql == '' ? '' : ' and ') + ' playerMin >= :min_player '
        where_variables[:min_player] =  params[:min_player].to_i
      end
  
  
      if params[:max_player].present? and (params[:max_player].to_i >= 0)
        where_sql += (where_sql == '' ? '' : ' and ') + ' playerMax <= :max_player '
        where_variables[:max_player] =  params[:max_player].to_i
      end
  

      # check the search result order 
      
  		secure_order = case params[:sort_by].to_i
  							when ORDER_MAX_TO_MIN_PRICE
  								"price DESC"
  							when ORDER_MAX_TO_MIN_PRICE
  								"price ASC"
  							when ORDER_Z_TO_A_NAME
  								"name DESC"
  							else # ORDER_A_TO_Z_NAME
  								"name ASC"
  							end   
  
  
      # return the information needed to query the database
  
      return [where_sql, where_variables, secure_order]
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :publisher_id, :designer_id, :price, :msrp, :imageUrl, :releasedate, :playerMin, :playerMax, :timeMin, :timeMax)
    end
end
