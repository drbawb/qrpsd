Factory.define :user do |f|
  f.sequence(:username) { |n| "drbob#{n}" }
  f.password "hoeMIAr1"
  f.sequence(:email) { |n| "test#{n}@test.com" }
  f.role "admin"
end