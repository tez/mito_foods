# == Schema Information
#
# Table name: areas
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Area < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, presence: true,
        		uniqueness: true
  validates :description, presence: true
end
