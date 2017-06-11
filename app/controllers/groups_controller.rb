class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path
      flash[:notice] = "Group create"
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
      flash[:notice] = "Update success"
    else
      render :edit
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      flash[:alert] = "Group deleted"
      redirect_to groups_path
    end
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end


end
