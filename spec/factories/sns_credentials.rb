FactoryBot.define do
  factory :sns_credential do
    provider { "facebook, google_oauth2" }
    uid { "123" }
    user { nil }
  end
end
