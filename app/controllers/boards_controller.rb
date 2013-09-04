class BoardsController < ApplicationController
  before_filter :find_board, :only => [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    @boards = Board.all
  end

  def show
    @posts = @board.posts
  end

  protected

  def find_board
    @board = Board.find(params[:id])
  end

  def record_not_found
    redirect_to boards_path, :notice => "Not found"
  end
end
