class SkillsController < ApplicationController
  def index
    @skills = Skill.all
  end
  
  def show
    @skill = Skill.find(params[:id])
  end
  
  def new
    @skill = Skill.new
  end
  
  def create
    @skill = Skill.new(params[:skill])
    if @skill.save
      flash[:notice] = "Successfully created skill."
      redirect_to @skill
    else
      render :action => 'new'
    end
  end
  
  def edit
    @skill = Skill.find(params[:id])
  end
  
  def update
    @skill = Skill.find(params[:id])
    if @skill.update_attributes(params[:skill])
      flash[:notice] = "Successfully updated skill."
      redirect_to @skill
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy
    flash[:notice] = "Successfully destroyed skill."
    redirect_to skills_url
  end
end
