class PostsController < ApplicationController
  before_filter :get_board

  def show
    if (@post = @board.posts.where(:id => params[:id]).first)
      render :show
    else
      redirect_to @board
    end
  end

  def new
    @post = @board.posts.build
  end

  def create
    @post = @board.posts.build(params[:post])
    if @post.save
      redirect_to [@board, @post]
    else
      render :new
    end
  end

  def edit
    if (@post = @board.posts.find_by_id(params[:id]))
      render :edit
    else
      redirect_to @board, :notice => "Post not found"
    end
  end

  def update
    if (post = @board.posts.find_by_id(params[:id]))
      if post.update_attributes(params[:post])
        redirect_to [@board, post], :notice => "Post has been updated!"
      else
        render :edit
      end
    else
      redirect_to @board, :notice => "Post not found"
    end
  end

  def destroy
    if (@post = @board.posts.find_by_id(params[:id]))
      if @post.destroy
        redirect_to @board, :notice => "Post has been deleted!"
      else
        redirect_to @board ,:notice => "Post cannot be deleted"
      end
    else
      redirect_to @board, :notice => "Post not found"
    end
  end

  protected

  def get_board
    @board = Board.find(params[:board_id])
  end
end
