Fabricator(:video) do 
  title { Faker::Lorem.words(3).join(' ') }
  description { Faker::Lorem.paragraphs(2).join }
end