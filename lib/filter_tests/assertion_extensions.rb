module FilterTests
  module AssertionExtensions
    def assert_filter(filter_type, filter_name, action)
      assert run_filter(filter_type, filter_name, action), "Expected #{@controller.class.name} to call #{filter_name} as a #{filter_type}_filter #{"on action \"#{action}\"" if action}"
    end

    def assert_not_filter(filter_type, filter_name, action)
      assert !run_filter(filter_type, filter_name, action), "Expected #{@controller.class.name} not to call #{filter_name} as a #{filter_type}_filter #{"on action \"#{action}\"" if action}"
    end
  
    def run_filter(filter_type, filter_name, action)
      filter = @controller.class.filter_chain.select(&:"#{filter_type}?").detect {|x| x.method == filter_name}
      return false unless filter
      if action.nil?
        return false if !filter.options[:except].nil? || !filter.options[:only].nil?
      end
      if action
        assert @controller.respond_to?(action), "Specified action #{action} is not an action on controller #{@controller.class.name}"
        @controller.action_name = action.to_s 
      end
      
      filter.send(:should_run_callback?, @controller)
    end
  end
end
