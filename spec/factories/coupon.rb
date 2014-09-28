FactoryGirl.define do
  factory :coupon do
    code { ('a'..'z').to_a.sample(5).join }
    status { [true,false].sample }
    user { create :user, :seller }
    discount { Random.rand(1..100) }
  end
end