class TokensController < ApplicationController
  load_and_authorize_resource :grid
  load_and_authorize_resource :token, :through => :grid
  
  rescue_from CanCan::AccessDenied do |exception|
    render :text => "#{exception.action}", :status => 403
  end
  
  def index
    @grid = Grid.find(params[:grid_id])
    @tokens = @grid.tokens.where('tokens.tblrow IS NOT NULL AND tokens.tblcol IS NOT NULL').order('turn_order').find(:all, :include => :character)
  end

  def new
    @grid = Grid.find(params[:grid_id])
    @token = Token.new
    @characters = Character.find(:all)
  end

  def edit
    @grid = Grid.find(params[:grid_id])
    @token = @grid.tokens.find(params[:id])
  end

  def create
    @grid = Grid.find(params[:grid_id])
    @token = @grid.tokens.new(params[:token])
    respond_to do |format|
      if @token.save
        flash[:notice] = 'Token was successfully created.'
        format.html { redirect_to(grid_tokens_path(@grid)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @token.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /grids/:grid_id/tokens/:id
  # params[:tblrow, :tblcol] => new x,y position
  def update
    @token = Token.find(params[:id])
    @grid = @token.grid
	
    if @token.tblrow.nil? || @token.tblcol.nil?
      @token = Token.new(:image_url => @token.image_url,
      :character => @token.character,
      :grid => @token.grid)
      @last_token = Token.where("grid_id = ? AND tblrow IS NOT NULL", @grid.id).maximum(:turn_order)
      @last_token.nil? ? @token.turn_order = 1 : @token.turn_order = @last_token + 1
    end
    
    if request.xhr?
      @token.attributes = {:tblrow => params[:token][:tblrow], :tblcol => params[:token][:tblcol]}
    else
      if can?(:update_turn_order, @token)
        @token.update_attributes(params[:token])
      end
    end
	
    respond_to do |format|
      if @token.save
        flash[:notice] = 'Token was successfully updated.'
        format.html { redirect_to(grid_tokens_path(@grid)) }
        format.json { render :json => { :response => "ok" } }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => {:response => "fail" } }
        format.xml  { render :xml => @token.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    cell = params[:cell].split("_")
    cell_x, cell_y = cell[1], cell[2]
    @token = Token.where(['id = ? AND tblrow = ? AND tblcol = ?', params[:id], cell_x, cell_y]).find(:first)
    @token.destroy if !(@token.nil?)
    render :nothing => true
  end
  
  
  #PUT /grids/:grid_id/tokens/:id/up
  def up
    @grid = Grid.find(params[:grid_id])
    @tokens = @grid.tokens.where('tokens.tblrow IS NOT NULL AND tokens.tblcol IS NOT NULL').order('turn_order')
    @token_1 = @tokens.find_by_id(params[:id])
    @token_2 = @tokens.where("turn_order = #{@token_1.turn_order - 1}").find(:first)

    temp = @token_1.turn_order
    @token_1.turn_order = @token_2.turn_order
    @token_2.turn_order = temp

    @token_1.save
    @token_2.save

    redirect_to(grid_tokens_path(@grid))
  end

  #PUT /grids/:grid_id/tokens/:id/up
  def down
    @grid = Grid.find(params[:grid_id])
    @tokens = @grid.tokens.where('tokens.tblrow IS NOT NULL AND tokens.tblcol IS NOT NULL').order('turn_order')
  
    Token.transaction do
      @token_1 = @tokens.find_by_id(params[:id])
      @token_2 = @tokens.where("turn_order = #{@token_1.turn_order + 1}").find(:first)
    end

    @token_1.swap_with(@token_2)
    
    Token.transaction do
      @token_1.save
      @token_2.save
    end
    
    redirect_to(grid_tokens_path(@grid))
  end
end
