module FilterTests
  module SetupControllerState
    def setup_controller_state(params={})
      setup_controller_request_and_response

      params = HashWithIndifferentAccess.new(({:controller => @controller.controller_name, :action => "index"}).merge(params))
      url = ActionController::UrlRewriter.new(@request, nil)
      url.rewrite(params)
      @controller.instance_variable_set :@url, url
      @controller.request = @request
      @controller.response = @response
      @controller.stubs(:params).returns params
      @controller.session = {}
      flash = Hash.new
      @controller.stubs(:flash).returns(flash)
      flash.stubs(:now).returns(flash)
    end
  end
end
