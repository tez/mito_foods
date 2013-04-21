# encoding: utf-8

require 'spec_helper'

describe "Genre pages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:genre, name: "hoge", description: "hogehoge")
      FactoryGirl.create(:genre, name: "fuga", description: "fugafuga")
      visit genres_path
    end

    it { should have_selector('title', text: 'All genres') }
    it { should have_selector('h1', text: 'All genres') }

    it "should list each genres" do
      Genre.all.each do |genre|
        page.should have_selector('li', text: genre.name)
      end
    end

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:genre) } }
      after(:all) { Genre.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each genre" do
        Genre.paginate(page: 1).each do |genre|
          page.should have_selector('li', text: genre.name)
        end
      end
    end

    describe "edit link" do
      it { should_not have_link('edit') }

      describe "an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit genres_path
        end

        it { should have_link('edit', href: edit_genre_path(Genre.first)) }
      end
    end

    describe "delete link" do
      it { should_not have_link('delete') }

      describe "an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit genres_path
        end

        it { should have_link('delete', href: genre_path(Genre.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(Genre, :count).by(-1)
        end
      end
    end
  end

  describe "new" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
      visit new_genre_path
    end

    let(:submit) { "Create new genre" }

    describe "page" do
      it { should have_selector('h1', text: "New genre") }
      it { should have_selector('title', text: "New genre") }
    end

    describe "with invalid information" do
      it "should not create a genre" do
        expect { click_button submit }.not_to change(Genre, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'New genre') }
        it { should have_content('error')}
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "和食"
        fill_in "Description",  with: "和食のジャンル"
      end

      it "should create a genre" do
        expect { click_button submit }.to change(Genre, :count).by(1)
      end

      describe "after saving the genre" do
        before { click_button submit }
        let(:genre) { Genre.find_by_name('和食') }

        it { should have_selector('title', text: genre.name) }
        it { should have_selector('div.alert.alert-success', text: 'Create') }
      end
    end
  end

  describe "edit" do
    let(:genre) { FactoryGirl.create(:genre) }
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
      visit edit_genre_path(genre)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update genre") }
      it { should have_selector('title', text: "Edit genre") }
    end

    describe "with invalid information" do
      before do
        fill_in "Name", with: " "
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_description) { "New Description" }
      before do
        fill_in "Name",         with: new_name
        fill_in "Description",  with: new_description
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }

      specify { genre.reload.name.should == new_name }
      specify { genre.reload.description.should == new_description}
    end
  end

  describe "show" do
    let(:genre) { FactoryGirl.create(:genre) }
    before { visit genre_path(genre) }

    it { should have_selector('h1', text: genre.name) }
    it { should have_selector('title', text: genre.name) }
  end
end
