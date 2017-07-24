class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
    @group.posts.build
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      if @group.posts.build
        p = @group.posts.create
        p.group = @group
        p.user = current_user
        p.save
      end
      current_user.join!(@group)
      redirect_to groups_path
      flash[:notice] = "Group created"
    else
      render :new
    end
  end

  def edit
    @group.posts.build if @group.posts.empty?
  end

  def update
    if @group.update(group_params)

        p = @group.posts.create
        p.group = @group
        p.user = current_user
        p.save

      redirect_to groups_path
      flash[:notice] = "Update success"
    else
      render :edit
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.rank(:row_order).paginate(:page => params[:page], :per_page => 5)
  end

  def destroy
    if @group.destroy
      flash[:alert] = "Group deleted"
      redirect_to groups_path
    end
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论版成功！"
    else
      flash[:warning] = "你已经是本讨论版成员了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已经退出本讨论版！"
    else
      flash[:warning] = "你不是本讨论版成员，怎么退出 XD"
    end

    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description, :posts_attributes => [:id, :content, :user_id, :_destroy])
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

end
