FactoryBot.define do
  factory :schedule do
    date        { '2026-12-1' }
    title       { 'テスト' }
    start_time  { '15:30' }
    end_time    { '20:30' }
    detail      { '詳細' }

    association :user
  end
end
