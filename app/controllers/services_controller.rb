#for handling json requests
class ServicesController < ApplicationController
  def store_pin
    response = User.store_pin(params)
    respond_to do |format|
      format.json {
        render :json => response.to_json
      }
    end
  end

  def forgot_pin
    response = User.forgot_pin(params)
    respond_to do |format|
      format.json {
        render :json => response.to_json
      }
    end
  end

  def forgot_password
    response = User.forgot_password_service(params)
    respond_to do |format|
      format.json {
        render :json => response.to_json
      }
    end
  end


def superbill_pull
    response = User.superbill_pull(params)
    respond_to do |format|
      format.json {
        render :json => response.to_json
      }
    end
  end




end
