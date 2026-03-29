# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Item.destroy_all
User.destroy_all

users = User.create!([
  {
    name: "user1",
    email: "user1@example.com",
    password: "123456",
    location: "SHHO",
    created_at: Time.current
  },
  {
    name: "user2",
    email: "user2@example.com",
    password: "233333",
    location: "UC",
    created_at: Time.current
  },
  {
    name: "user3",
    email: "user3@example.com",
    password: "66666",
    location: "SHAW",
    created_at: Time.current
  }
])

items = [
  {
    name: "Laptop",
    description: "512G, Macbook PRO",
    price: 6666.00,
    post_date: "2025-03-06",
    category: "eletronics",
    seller_id: users[1].id,
    image_path: "app/assets/images/macbook.jpeg"
  },
  {
    name: "Bicycle",
    description: "Latest Design",
    price: 500.00,
    post_date: "2022-08-12",
    category: "sports",
    seller_id: users[0].id,
    image_path: "app/assets/images/bicycle.jpeg"
  },
  {
    name: "Guitar",
    description: "YAMAHA Brand",
    price: 1200.00,
    post_date: "2022-06-13",
    category: "other",
    seller_id: users[1].id,
    image_path: "app/assets/images/guitar.jpeg"
  },
  {
    name: "Lamp",
    description: "LED and eye-protective",
    price: 120.00,
    post_date: "2023-09-01",
    category: "furniture",
    seller_id: users[2].id,
    image_path: "app/assets/images/lamp.jpeg"
  },
  {
    name: "Novel",
    description: "Nobel Prize Winner",
    price: 40.00,
    post_date: "2026-02-25",
    category: "books",
    seller_id: users[0].id,
    image_path: "app/assets/images/novel.jpeg"
  }
]

items.each do |data|
  item = Item.create!(
    name: data[:name],
    description: data[:description],
    price: data[:price],
    post_date: data[:post_date],
    category: data[:category],
    seller_id: data[:seller_id]
  )
  
  if File.exist?(data[:image_path])
    item.photo.attach(
      io: File.open(data[:image_path]),
      filename: File.basename(data[:image_path]),
      content_type: "image/jpeg"
    )
  else
    puts "Image not found: #{data[:image_path]}"
  end
end
