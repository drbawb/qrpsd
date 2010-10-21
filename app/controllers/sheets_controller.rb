class SheetsController < ApplicationController
  # GET /sheets
  # GET /sheets.xml
  def new
    @sheet = Sheet.new
  end

  def create
    @sheet = Sheet.new(params[:sheet])
    @user_ses = current_user
	if @sheet.save
      flash[:notice] = 'File was successfully created.'
      redirect_to sheet_url(@sheet)     
    else
      render :action => :new
    end
  end
  
  def show
    @sheet = Sheet.find(params[:id])
  end
  
  def index
    if params[:character_id]
      @character = Character.find(params[:character_id])
      @sheets = @character.sheets
    else
      @sheets = Sheets.find(:all)
    end
  end
  
end