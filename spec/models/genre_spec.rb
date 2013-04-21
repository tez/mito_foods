# == Schema Information
#
# Table name: genresrequire "genre_spec"
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Genre do

  before{ @genre = Genre.new(name: "exampe", description: "example description" ) }

  subject { @genre }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "when name is not present" do
    before { @genre.name = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @genre.description = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      genre_with_same_name = @genre.dup
      genre_with_same_name.save
    end

    it { should_not be_valid }

  end
end