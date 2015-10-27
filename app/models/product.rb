class Product < ActiveRecord::Base
  attr_protected
  validates :purchased_date, :date => { :message => "^Date must be in the following format: yyyy-mm-dd" }
end
