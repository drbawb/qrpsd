Factory.define :character do |f|
  f.association :user
  f.association :campaign
  f.name "Testchar"
  f.race "Testrace"
  f.char_class "Testclass"
end