class EventsController < ApplicationController

  def new
    @event = Event.new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    @event = @group.events.new(event_params)
    if @event.save
      EventMailer.notice_event(@group, @event).deliver_now
      redirect_to group_event_path(params[:group_id],@event.id)
    else
      render :new
    end
  end
  
  def show
    @event=Event.find(params[:id])
  end
  
  # def complete
  #   @event=event
  # end

  private

  def event_params
    params.require(:event).permit(:title, :content)
  end
end
