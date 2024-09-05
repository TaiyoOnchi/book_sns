class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  def new
    @group=Group.new
  end
  
  
  def create
    @group = Group.new(group_params)
    @group.owner_id=current_user.id
    if @group.save
      redirect_to groups_path, notice: "You have created book successfully."
    else
      render 'new'
    end
  end
  
  
  def index
    @groups=Group.all
    @book=Book.new
    
  end
  
  
  def show
    @group = Group.find(params[:id])
    @user=User.find(current_user.id)
    @book=Book.new
    @users = @group.users
    @owner_user=User.find(@group.owner_id)
    
  end
  
  
  def edit
  end
  
  
  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "You have updated book successfully."
    else
      render "edit"
    end
  end
  
  
  def delete
    
  end
  
  
  private
  def group_params
    params.require(:group).permit(:name, :introduction,:group_image)
  end
  
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
