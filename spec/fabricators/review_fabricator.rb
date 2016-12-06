Fabricator(:review) do 
  rating { [1, 2, 3, 4, 5].sample }
  body { Faker::Lorem.paragraph(5) }
end