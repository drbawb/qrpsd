class GridsController < ApplicationController
  load_and_authorize_resource
  def index
    @grids = Grid.find(:all)   
  end
  
  def show
    if request.xhr?
      @grid = Grid.find(params[:id], :include => :tokens)
    else
      @roll = Roll.new #new roll for us to make a form for.
      @debug = "not saved yet"
      @grid = Grid.find(params[:id])
    end
    
    respond_to do |format|
      format.html # show.rhtml
      format.js #show.js.rjs
      #format.xml  { render :text => @grid.tablerefresh  }
      #format.js { render :text => @grid.tablerefresh  }
    end
  end
  
  def tablerefresh
    @grid = Grid.find(params[:id], :include => :tokens)
    render :text => @grid.tablerefresh
  end
  
  def new
  @grid = Grid.new
  @campaigns = Campaign.find(:all, :conditions => "user_id = #{current_user.id}") #Campaigns you own
  respond_to do |format|
  format.html # new.html.erb
  format.xml  { render :xml => @grid }
  end
  end
  
  def create
    @grid = Grid.new(params[:grid])
    
    respond_to do |format|
      if @grid.save
        flash[:notice] = 'Grid was successfully created.'
        format.html { redirect_to(@grid) }
        format.xml  { render :xml => @grid, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grid.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @grid = Grid.find(params[:id], :include => { :tokens => :character })
    @tokens = @grid.tokens
    @input = params[:secretsauce].split("_")
    if request.xhr?
	  last_turn = @tokens.last.turn_order
	  last_turn ||= 0
	  
      token = @grid.tokens.find(@input[0].split('c')[0])
      if (current_user.role == 'admin') || (current_user.id == token.character.user.id)
        if token.tblrow.nil? || token.tblcol.nil?
          base_token = token
          token = Token.new(:character_id => base_token.character_id, :grid_id => base_token.grid_id, :image_url => base_token.image_url, :turn_order => last_turn + 1)
        end
        if token.tblrow != @input[1] && token.tblcol != @input[2]
          #We are only going to perform an UPDATE if the token has moved
          token.attributes={:tblrow => @input[1], :tblcol => @input[2]}
          token.save
        end
      else
        @error = "You apparently do not have permissions to move this token! Changes will be reverted at the next refresh."
      end
    end

    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    #Heh, you can't delete it yet, that's funny. God I'm terrible.
  end
end
