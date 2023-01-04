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
    password: row['password'],
    created_at: Time.now,
    updated_at: Time.now
  }
end
instances.each do |hash|
  @user = User.new(
    name: hash[:name],
    password: hash[:password]
  )
  @user.save
end
