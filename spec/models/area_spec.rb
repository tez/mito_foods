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

require 'spec_helper'

describe Area do

	before { @area = Area.new(name: "example", description: "example description") }

	subject { @area }

	it { should respond_to(:name) }
	it { should respond_to(:description) }

	it { should be_valid }

	describe "when name is not present" do
		before { @area.name = " " }
	  it { should_not be_valid }
	end

	describe "when description is not present" do
		before { @area.description = " " }
		it { should_not be_valid }
	end
  
  describe "when name is already taken" do
    before do
      area_with_same_name = @area.dup
      area_with_same_name.save
    end
    
    it { should_not be_valid }
      
  end
end
