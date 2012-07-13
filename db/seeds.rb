# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.create([{:first_name => "Kumquat", :last_name=> "New", :email => 'testemail@kumquat.com', :password => 'password', :password_confirmation => 'password'},
  {:first_name => "Boyang", :last_name => "Niu", :email=>'boyang.niu@gmail.com', :password=>'GothicBoing0', :password_confirmation => 'GothicBoing0'},
  {:first_name => "Demoseus", :last_name => "Youknowit",:email=>'kumquatexpress@gmail.com',:password=>'GothicBoing0', :password_confirmation => 'GothicBoing0'}])
  

