require 'test_helper'
require File.dirname(__FILE__) + '/../lib/filter_tests/assertion_extensions'

class FakeController < ActionController::Base
  before_filter :before_method, :only => [:action]
  after_filter :after_method, :only => [:action]
  around_filter :around_method, :only => [:action]
  before_filter :check_admin, :only => [:action]
  before_filter :check_siteadmin, :only => [:action]
  before_filter :not_every_action, :except => [:other_action]
  before_filter :every_action
  
  def action
    
  end
  
  def other_action
    
  end

  private 
  
  def before_method
    
  end
  
  def after_method
    
  end
  
  def around_method
    
  end
  
  def check_admin
    
  end
  
  def check_siteadmin
    
  end
  
end

class AssertionExtensionsTest < ActionController::TestCase
  include FilterTests::AssertionExtensions
  
  tests FakeController

  context "assert_filter_with" do
    should "fail and report" do
      exception = assert_raises Test::Unit::AssertionFailedError do
        assert_filter :after, :after_method, :other_action
      end
      assert_match(/Expected .* to call/, exception.message)
    end
    
    should "fail on nonexistent filter with no action specified" do
      exception = assert_raises Test::Unit::AssertionFailedError do
        assert_filter :after, :bogus_method, nil
      end
      assert_no_match(/on action/, exception.message)
    end
    
    should "fail on nonexistent action with filter for every action" do
      exception = assert_raises Test::Unit::AssertionFailedError do
        assert_filter :before, :every_action, :bogus_action
      end
      assert exception.message.include?("bogus_action is not an action")
    end
    
    context "when action is not specified" do
      should "fail when there are actions that don't use that filter" do
        exception = assert_raises Test::Unit::AssertionFailedError do
          assert_filter :before, :not_every_action, nil
        end
      end
    
      should "succeed when all actions use that filter" do
        assert_filter :before, :every_action, nil
      end
    
      should "fail when filter isn't called" do
        exception = assert_raises Test::Unit::AssertionFailedError do
          assert_filter :before, :does_not_exist, nil
        end
      end
    end
    
  end

  context "assert_not_filter_with" do
    should "fail and report" do
      exception = assert_raises Test::Unit::AssertionFailedError do
        assert_not_filter :after, :after_method, :action
      end
      assert_match(/Expected .* not to call/, exception.message)
    end
  end
end
