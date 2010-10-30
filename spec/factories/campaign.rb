Factory.define :campaign do |f|
  f.association :user
  f.title "Testpaign"
  f.description "Testdesc"
end