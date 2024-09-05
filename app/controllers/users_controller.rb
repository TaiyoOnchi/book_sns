class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books.sort_by { |book| -book.favorites.count }
    @book = Book.new


    @books_today = Book.where(created_at: Time.zone.today.all_day).count #今日の投稿数
    @books_yesterday = Book.where(created_at: 1.day.ago.all_day).count #前日の投稿数
    # @books_yesterday=2

    if @books_yesterday > 0
      @day_ratio = (@books_today.to_f / @books_yesterday * 100).round(0) #前日比計算
    else
      @day_ratio = 0
    end


    @books_this_week = Book.where(created_at: Time.zone.now.all_week).count
    @books_last_week = Book.where(created_at: 1.week.ago.all_week).count
    # @books_last_week=4

    if @books_last_week > 0
      @week_ratio = (@books_this_week.to_f / @books_last_week * 100).round(0) #前週比計算
    else
      @week_ratio = 0
    end

    @days = []
    @weekly_books = []
    (0..6).each do |i|
      @days[i] = (6-i).days.ago.strftime("%Y-%m-%d")
      @weekly_books[i] = Book.where(created_at: (6-i).days.ago.all_day).count
    end
      if current_user == @user
      @show_address = true
    else
      @show_address = false
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  def search
    selected_date = Date.parse(params[:selectedDate]) # パラメータから日付をパース
    @books_num = Book.where(created_at: selected_date.beginning_of_day..selected_date.end_of_day).count
    render 'replace_btn'
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :postcode,
      :prefecture_code, :address_city, :address_street, :address_building)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
