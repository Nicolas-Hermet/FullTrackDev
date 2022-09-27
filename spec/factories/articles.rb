FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { nil }
    category { :tech }
    status { :draft }
  end
end
