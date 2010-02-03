require 'test_helper'
require File.dirname(__FILE__) + '/../lib/filter_tests/setup_controller_state'

class FakeController < ActionController::Base
  def index
  end
end

ActionController::Routing::Routes.draw do |map|
  map.connect "/fake/index", :controller => "fake", :action => "index"
  map.connect "/not_fake/not_index", :controller => "not_fake", :action => "not_index"
end

class SetupControllerStateTest < ActionController::TestCase
  include FilterTests::SetupControllerState
  tests FakeController

  context "setup_controller_state" do
    should "setup request, response, url, session and flash" do
      setup_controller_state
      assert_not_nil @controller.request
      assert_equal ActionController::TestRequest, @controller.request.class
      assert_not_nil @controller.response
      assert_equal ActionController::TestResponse, @controller.response.class
      assert_not_nil @controller.instance_variable_get(:@url)
      assert_equal ActionController::UrlRewriter, @controller.instance_variable_get(:@url).class
      assert_equal Hash.new, @controller.session
      assert_equal Hash.new, @controller.flash
    end
    
    context "flash" do
      should "store flash messages" do
        setup_controller_state
        
        @controller.flash[:error] = "error!"
        assert_equal "error!", @controller.flash[:error]
      end
      
      should "allow setting flash.now" do
        setup_controller_state
        
        @controller.flash.now[:emergency] = "Bad error!"
        assert_equal "Bad error!", @controller.flash[:emergency]
      end
    end
    
    
    context "for params" do
      should "setup params to @controller: name and action: index by default" do
        setup_controller_state
      
        assert_equal "fake", @controller.params[:controller]
        assert_equal "fake", @controller.params["controller"]
        assert_equal "index", @controller.params[:action]
        assert_equal "index", @controller.params["action"]
      end
    
      should "override params with passed-in params" do
        setup_controller_state :controller => "not_fake", :action => "not_index", :id => "-1"

        assert_equal "not_fake", @controller.params[:controller]
        assert_equal "not_index", @controller.params[:action]
        assert_equal "-1", @controller.params[:id]
      end
    end
    
  end
  
end
