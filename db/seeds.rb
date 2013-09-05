# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# create first user as admin
user_admin = User.new(
  :email => "bruce@techbang.com.tw",
  :password => "abcd1234",
  :password_confirmation => "abcd1234"
)
user_admin.is_admin = true
user_admin.save


# create a test user, which is not an admin
user = User.new(
  :email => "bruce@gmail.com.tw",
  :password => "abcd1234",
  :password_confirmation => "abcd1234"
)
user.save


# create deafult board
board = Board.create!(
  :name => "BBS"
)

# create default post
post = board.posts.build(
  :title => "Hello world",
  :content => "Hi! This is your first post!\n\nWelcome!"
)

post.user = user_admin
post.save!

