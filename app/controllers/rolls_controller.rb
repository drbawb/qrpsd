class RollsController < ApplicationController
  # GET /rolls
  # GET /rolls.xml
  load_and_authorize_resource
  respond_to :html, :xml
  respond_to :js, :only => :create

  def index
    redirect_to new_roll_path
    #  respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @rolls }
    #end
  end

  # GET /rolls/1
  # GET /rolls/1.xml
  def show
    @roll = Roll.find(params[:id])
    @roll_new = Roll.new
  end

  # GET /rolls/new
  # GET /rolls/new.xml
  def new
    @roll = Roll.new
    respond_with(@roll)
  end

  # GET /rolls/1/edit
  def edit
    flash[:notice] = 'Rolls are locked from being edited, sorry.'
    redirect_to root_url
  end

  # POST /rolls
  # POST /rolls.xml

    def create
     @roll = Roll.new(params[:roll])
    respond_to do |format|
      if @roll.save
        flash[:notice] = 'Roll was successfully created.'
        format.html { redirect_to(@roll) }
	format.js { render :layout => false }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @roll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rolls/1
  # PUT /rolls/1.xml
  
	def update
		flash[:notice] = 'Rolls are locked from being edited, sorry.'
		redirect_to root_url
  end

  # DELETE /rolls/1
  # DELETE /rolls/1.xml
  def destroy
    @roll = Roll.find(params[:id])
    unauthorized! if cannot? :destroy, @roll
		@roll.destroy

    respond_to do |format|
      format.html { redirect_to(rolls_url) }
      format.xml  { head :ok }
    end
  end
end
