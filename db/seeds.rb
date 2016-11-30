# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "Comedies")
Category.create(name: "Dramas")


Video.create(title: 'Family Guy', description: 'A hilarious show about a disorderly family', small_cover_url: "family_guy")
Video.create(title: 'Monk', description: 'An emotionally damaged detective solves the most intractable crimes', small_cover_url: "monk")
Video.create(title: 'South Park', description: 'The kids from South Park are back for more shenanigans', small_cover_url: "south_park")
Video.create(title: 'Futurama', description: 'A space comedy of ingenious design', small_cover_url: "futurama")
Video.create(title: 'South Park', description: 'The kids from South Park are back for more shenanigans', small_cover_url: "south_park")
Video.create(title: 'South Park', description: 'The kids from South Park are back for more shenanigans', small_cover_url: "south_park")