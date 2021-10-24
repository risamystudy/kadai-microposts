(1..10).each do |number|
  Micropost.create(content: 'test content ' + number.to_s, user_id: '3')
end