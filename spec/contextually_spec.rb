require File.expand_path('spec_helper', File.dirname(__FILE__))

Contextually.define do
  roles :user, :visitor, :monkey

  group :user, :monkey, :as => :member
  group :visitor, :monkey, :as => :idiot

  before_all do
    controller.stub!(:global_before).and_return(true)
  end

  before :user do
    controller.stub!(:current_user).and_return(:user)
  end
  before :visitor do
    controller.stub!(:current_user).and_return(nil)
  end
  before :monkey do
    controller.stub!(:current_user).and_return(:monkey)
  end

  deny_access_to :visitor do
    it("should deny access") { should redirect_to(new_session_url) }
  end
  deny_access do
    it("should deny access") { should redirect_to(root_url) }
  end
end

ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'monkey'
  map.new_session 'session', :controller => 'session'
  map.index 'tests', :controller => 'tests', :action => 'index'
  map.index 'test', :controller => 'tests', :action => 'show'
  map.index 'foo', :controller => 'tests', :action => 'foo'
end

class TestsController < ApplicationController
  def index
    raise "global before not run" unless global_before
    if not current_user
      redirect_to new_session_url
    elsif not current_user == :user
      redirect_to root_url
    end    
  end
  
  def foo
    if not current_user
      redirect_to new_session_url
    end
  end
  
  def show
    
  end
end

describe TestsController, :type => :controller do
  context "with simple contexts" do
    as :user, :get => :index do
      it { should respond_with(:success) }
    end
  
    as :visitor, :get => :index do
      it("should deny access") { should redirect_to(new_session_url) }
    end
  end
  
  context "with multiple roles" do
    as :visitor, :monkey, :user, :get => :show do
      it { should respond_with(:success) }
    end
    
    as :visitor, :monkey, :user, "GET /test" do
      describe :get => :show do
        it { should respond_with(:success) }
      end
    end

    as :visitor, :monkey, :user do
      describe :get => :show do
        it { should respond_with(:success) }
      end
    end
  end
  
  context "with only_as" do
    only_as :user, :get => :index do
      it { should respond_with(:success) }
    end
  end
  
  context "with deny access" do
    deny_access_to :monkey, :visitor, :get => :index
  end
  
  context "with groups" do
    deny_access_to :idiot, :get => :index
  
    only_as :member, :get => :foo do
      it { should respond_with(:success) }
    end
  end

  context "with only_allow_access_to" do
    only_allow_access_to :user, :get => :index
  end
end

