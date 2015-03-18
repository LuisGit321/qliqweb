class SubscriptionsController < ApplicationController

  layout 'home'

  def new
    @subscriber       = ProspectiveSubscriber.new
    @physician_group  = PhysicianGroup.new
    @states           = State.all
  end

  def create_group
    @physician_group  = PhysicianGroup.new params[ :physician_group ]
    @result           = { :status => :fail }
    if @physician_group.save
      @result[ :status ] = :ok
    end
    respond_to do |format|
      format.json { render :json => @result }
    end
  end

end
