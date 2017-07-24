class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group), notice: "Post created."
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @posts = @group.posts
  end

  def destroy
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to account_posts_path
      flash[:alert] = "Post Deleted."
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
  end

  def update
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to account_posts_path
      flash[:notice] = "Update Success."
    else
      render :edit
    end
  end

  def reorder
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.row_order_position = params[:position]
    @post.save!

    respond_to do |format|
      format.html { redirect_to group_path(@group) }
      format.json { render :json => { :message => "ok" } }
    end

  end





  private

  def post_params
    params.require(:post).permit(:content)
  end
end
