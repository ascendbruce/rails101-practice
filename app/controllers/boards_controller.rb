class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    if (@board = Board.find_by_id(params[:id]))
      @posts = @board.posts
      render :show
    else
      redirect_to boards_path, :notice => "Board not found"
    end
  end

  def new
    @board = Board.new
  end

  def create
    if (@board = Board.create(params[:board]))
      redirect_to @board
    else
      render :new
    end
  end

  def edit
    if (@board = Board.find_by_id(params[:id]))
      render :edit
    else
      redirect_to boards_path, :notice => "Board not found"
    end
  end

  def update
    if (@board = Board.find_by_id(params[:id]))
      if @board.update_attributes(params[:board])
        redirect_to @board, :notice => "Board updated"
      else
        render :new
      end
    else
      redirect_to boards_path, :notice => "Board not found"
    end
  end

  def destroy
    if (@board = Board.find_by_id(params[:id]))
      if @board.destroy
        redirect_to @board, :notice => "Board updated"
      else
        render :new
      end
    else
      redirect_to boards_path, :notice => "Board not found"
    end
  end
end
