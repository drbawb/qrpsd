Factory.define :token do |f|
  f.association :character
  f.association :grid
  f.image_url "BunBun.png"
  f.tblrow nil
  f.tblcol nil
  f.turn_order nil
end