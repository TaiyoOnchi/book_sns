class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @book.views_count += 1
    @book.save
  end

  def index
    # tagsテーブルと結合し、タグ名を使った検索が可能に
    @q = Book.joins(:tags).ransack(search_params)
    # ユーザーと関連付けられたレコードを含め、いいねの数でソート
    @books = Book.all.sort_by { |book| -book.favorites.count }
    @book = Book.new
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name)  # 既存のタグのリストを取得
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_name = params[:book][:tag_name]
    # タグが存在するかチェックして、なければ新しく作成する
    tag = Tag.find_or_create_by(name: tag_name)
    @book.tag = tag
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def new_sort
    @books = Book.all.sort_by { |book| -book.created_at.to_i }
    render 'replace_btn'
  end

  def rating_sort
    @books = Book.all.sort_by { |book| -(book.rating || 0) }
    render 'replace_btn'
  end

  def search
    @q = Book.joins(:tags).ransack(search_params)
    # ユーザーと関連付けられたレコードを含め、いいねの数でソート
    @books = @q.result(distinct: true).includes(:user).sort_by { |book| -book.favorites.count }
    render 'replace_btn'
  end


  private

  def book_params
    params.require(:book).permit(:title, :body,:rating,:tag_list)
  end
  def search_params
    params.fetch(:q, {}).permit(:title_cont, :body_cont, :rating_eq, :user_name_cont, :with_tag_name)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
