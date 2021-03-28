# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create!([
                       {email: 'pupa@ex.com', password: '123456', password_confirmation: '123456'},
                       {email: 'lupa@ex.com', password: '123456', password_confirmation: '123456'}
                     ])

questions = Question.create!([
                               {title: 'First question', body: 'body', user: users[0]},
                               {title: 'Second question', body: 'body', user: users[1]}
                             ])

answers = Answer.create!([
                           {body: 'answer1', question: questions[0], user: users[0]},
                           {body: 'answer2', question: questions[0], user: users[1]}
                         ])
