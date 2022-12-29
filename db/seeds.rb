# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'
instances = CSV.open('db/data/keywords.csv', headers: true).to_a.map do |row|
  {
    option: row['option'],
    question: row['question'],
    created_at: Time.now,
    updated_at: Time.now
  }
end
instances.each do |hash|
  keyword = Keyword.find_or_initialize_by(option: hash[:option], question: hash[:question])
  keyword.save
end

instances = CSV.open('db/data/users.csv', headers: true).to_a.map do |row|
  {
    name: row['name'],
    email: row['email'],
    password: row['password'],
    created_at: Time.now,
    updated_at: Time.now
  }
end
instances.each do |hash|
  @user = User.new(
    name: hash[:name],
    email: hash[:email],
    password: hash[:password]
  )
  @user.save
end

user_max = User.all.count
keyword_max = Keyword.all.count
200.times do |i|
  vote = Vote.find_or_initialize_by(
    voter_id: rand(user_max),
    voted_id: rand(user_max),
    keyword_id: rand(keyword_max)
  )
  vote.save
end
