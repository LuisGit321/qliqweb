class Admin::HomeController < ApplicationController
  layout 'admin'

  def index
  end

  def reset_password
    @user = User.find(params[:id])
    @attempt = params[:attempt].to_i
    if request.get?
      respond_to do |format|
        if @attempt == 1
          format.html { render :layout => 'application' } 
        else
          format.html { render :layout => false } 
        end
        format.js {
          render :partial => 'reset_password'
        }
      end
    else
      success =  @user.reset_password!(params[:user][:password], params[:user][:password_confirmation])
      if user_signed_in?   
        respond_to do |format|
          if success
            flash[:notice] = 'Password is successfully changed.'
            format.js {
              render :js => @attempt == 1 ? "window.location='#{my_home_path(@user)}'" : "window.location='#{request.referrer}'"
            }
          else
            format.html { render :layout => 'application' } 
            format.js {
              render :partial => 'reset_password'
            }
          end
        end
      else
        respond_to do |format|
          if success
            sign_in(@user)
            current_user = @user if @attempt == 1
            format.js {
              render :js => @attempt == 1 ? "window.location='#{my_home_path(@user)}'" : "window.location='#{request.referrer}'"
            }
          else
            format.html { render :layout => 'application' } 
            format.js {
              render :partial => 'reset_password'
            }
          end
        end
      end
    end
  end
end
