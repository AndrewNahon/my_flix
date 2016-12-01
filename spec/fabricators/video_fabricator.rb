Fabricator(:video) do 
  title { Faker::Lorem.word }
  description { Faker::Lorem.paragraphs(2).join }
end