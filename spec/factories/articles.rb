FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { nil }
    category { 1 }
    status { 1 }
    modified_at { "2022-04-05 18:27:30" }
  end
end
