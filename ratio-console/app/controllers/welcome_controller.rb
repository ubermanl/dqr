class WelcomeController < ApplicationController
  def index
    @pinned_modules = DeviceModule.pinned
  end
end
