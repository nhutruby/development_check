Factory.sequence :random do |n|
  n
end

Factory.define :user do |user|
  user.name_first             "Jhon"
  user.name_last              "Doe"
  user.email                  "jhon.doe_#{Factory.next(:random)}@gmail.com"
  user.password               "default"
  user.password_confirmation  "default"
end