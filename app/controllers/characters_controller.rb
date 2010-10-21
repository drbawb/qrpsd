class CharactersController < ApplicationController
  # GET /characters
  # GET /characters.xml
  load_and_authorize_resource
  def index
    @characters = Character.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @characters }
    end
  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
    @character = Character.find(params[:id], :include => [:user, :sheets, :skills])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/new
  # GET /characters/new.xml
  def new
    @character = Character.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id], :include => { :player_skills =>  :skill })
    stub_player_skills
  end

  # POST /characters
  # POST /characters.xml
  def create
    @character = Character.new(params[:character])
    if current_user
      @character.user_id = current_user.id
    else
      @character.user_id = 0
    end
    
    respond_to do |format|
      if @character.save
        flash[:notice] = 'Character was successfully created.'
        format.html { redirect_to(@character) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.xml
  def update
    @character = Character.find(params[:id])
    params[:character][:player_skills_attributes].delete_if do |key, val|
      params[:character][:player_skills_attributes][key][:level] == ""
    end unless params[:character][:player_skill_attributes].nil?

    respond_to do |format|
      if @character.update_attributes(params[:character])
        flash[:notice] = "Character successfully updated!"
        format.html { redirect_to(@character) }
      else #Update failed! RUN AROUND LIKE A CHICKEN WITH YOUR HEAD CUT OFF!
        @character.reload
        flash[:notice] = "Character NOT updated! Reset to prior condition."
        stub_player_skills
        format.html { render :action => 'edit' }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.xml
  def destroy
    @character = Character.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to(characters_url) }
      format.xml  { head :ok }
    end
  end

  private
  def stub_player_skills
    #ps = @character.player_skills.build(:skill_id => skill.id, :name => skill.name) if skill_exists.empty?
    @skills = Skill.find(:all)

    skill_ids = @skills.map { |x| x.id }
    ps_ids = @character.player_skills.map { |x| x.skill.id }

    stub_ids = skill_ids - ps_ids #Returns array of skill ID #'s that the player doesn't have
    deselected_skills = @skills.select { |i| stub_ids.include? i.id } #Returns array of Skill objects that the player doesn't have

    deselected_skills.each do |skill|
      ps = @character.player_skills.build(:skill_id => skill.id, :name => skill.name) #Builds a PlayerSkill for each deselected skill
    end

    @skill_arr = @character.player_skills.map { |el| el.name.nil? ? el.skill.name : el.name } #Maps it to an array so the view doesn't iterate over 9000+ skills!
  end
end
