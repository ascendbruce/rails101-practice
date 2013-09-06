# encoding: utf-8

class AddPostsCountToBoard < ActiveRecord::Migration
  def up
    add_column :boards, :posts_count, :integer

    Board.find_each do |board|
      Board.reset_counters(board.id, :posts)
    end
  end

  def down
    remove_column :boards, :posts_count
  end
end
