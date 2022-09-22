FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { nil }
    category { :tech }
    status { :draft }
    published_at { "2022-04-05 18:27:30" }
  end
end
