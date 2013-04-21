# encoding: UTF-8

require 'spec_helper'

describe "Area pages" do

  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:area, name: "hoge", description: "hogehoge")
      FactoryGirl.create(:area, name: "fuga", description: "fugafuga")
      visit areas_path
    end
  
    it { should have_selector('title', text: "All areas") }
    it { should have_selector('h1', text: "All areas") }
    
    it "should list each areas" do
      Area.all.each do |area|
        page.should have_selector('li', text: area.name)
      end
    end 
    
    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:area) } }
      after(:all) { Area.delete_all }
      
      it { should have_selector('div.pagination') }
      
      it "should list each area" do
        Area.paginate(page: 1) do |area|
          page.should have_selector('li', text: area.name)
        end
      end
    end

    describe "edit link" do
      it { should_not have_link('edit') }

      describe "an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit areas_path
        end

        it { should have_link('edit', href: edit_area_path(Area.first)) }
      end
    end
    
    describe "delete link" do
      it { should_not have_link('delete') }
      
      describe "an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit areas_path
        end
        
        it { should have_link('delete', href: area_path(Area.first)) }       
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(Area, :count).by(-1)
        end
      end
    end
  end

  describe "new" do
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
      visit new_area_path
    end

    let(:submit) { "Create new area" }

    describe "page" do
      it { should have_selector('h1', text: "New area") }
      it { should have_selector('title', text: "New area") }
    end

    describe "with invalid information" do
      it "should not create a area" do
        expect { click_button submit }.not_to change(Area, :count)
      end

      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'New area') }
        it { should have_content('error') }
      end
    end  
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "下市"
        fill_in "Description",  with: "下市エリア"
      end
      
      it "should create a area" do
        expect { click_button submit }.to change(Area, :count).by(1)        
      end
      
      describe "after saving the area" do
        before { click_button submit }
        let(:area) { Area.find_by_name("下市") }
      
        it { should have_selector('title', text: area.name) }
        it { should have_selector('div.alert.alert-success', text: 'Create') }
      end  
    end    
  end
  
  describe "edit" do
    let(:area) { FactoryGirl.create(:area) }
    before do
      user = FactoryGirl.create(:user)
      sign_in(user)
      visit edit_area_path(area)
    end
    
    describe "page" do
      it { should have_selector('h1', text: "Update area") }
      it { should have_selector('title', text: "Edit area") }
    end
    
    describe "with invalid information" do
      before do
        fill_in "Name", with: " "
        click_button "Save change"        
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

      specify { area.reload.name.should == new_name }
      specify { area.reload.description.should == new_description }
    end
  end
  
  describe "show" do
    let(:area) { FactoryGirl.create(:area) }
    before { visit area_path(area) }
    
    it { should have_selector('h1', text: area.name)}
    it { should have_selector('title', text: area.name)}
  end  
end