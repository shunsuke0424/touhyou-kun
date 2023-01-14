module Admin
  class BaseController < ApplicationController
    before_action :check_permission

    def check_permission
      return redirect_to("/"),flash[:notice] = "権限がありません" unless controller_action_authrized?
    end

    def controller_action_authrized?
      raise '各controllerで定義すること'
    end
  end
end
