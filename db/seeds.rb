# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ code: 'Star Wars' }, { code: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

c = Currency.new(id:1, code:'usd', val:0, forced_val: 10.0, forced_till: Time.zone.now, forced:false, description:'USA dollar')
c.save(validate: false)