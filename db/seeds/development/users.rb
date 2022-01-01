# メインのサンプルユーザーを1人作成する
User.create!(
  id: 1,
  name: "Admin User",
  email: "admin0000@admin.com",
  password: "admin0000",
  admin: true
)

User.create!(
  id: 2,
  name: "Guest User",
  email: "guest@example.com",
  password: "guest0000",
  admin: false
)

10.times do |n|+2
  name = Faker::Name.name
  email = "user#{n+1}@example.com"
  user = User.find_or_initialize_by(
    email: email, activated: true
  )

  if user.new_record?
    user.name = name
    user.password = "password"
    user.save!
  end
end
