FactoryBot.define do
  factory :post do
    user_id { 1 }
    title { "MyString" * 3 }
    body { "MyText" * 30 }
    image {"Rack::Test::UploadedFile.new(File.join(Rails.root,'app/assets/images/no-image.png'))"}
    image_id { "MyString" }
    association :user
  end
end
