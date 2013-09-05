# encoding: utf-8

class AddPostsCountToBoard < ActiveRecord::Migration
  def up
    add_column :boards, :posts_count, :integer

    #TODO: migration 內有code是可接受的嗎? && 先寫 assosication counter_cache 的話這個migration會爆炸
    Board.all.each do |board|
      board.update_attribute(:posts_count, board.posts.count)
    end
  end

  def down
    remove_column :boards, :posts_count
  end
end
