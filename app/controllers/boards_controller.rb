class BoardsController < ApplicationController
  before_filter :find_board, :only => [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @boards = Board.all
  end

  def show
    @posts = @board.posts
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.create(params[:board])
    if @board
      redirect_to @board
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @board.update_attributes!(params[:board])
      redirect_to @board, :notice => "Board updated"
    else
      render :edit
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path, :notice => "Board updated"
  end


  protected

  def find_board
    @board = Board.find(params[:id])
  end

  def record_not_found
    redirect_to boards_path, :notice => "Not found"
  end
end
