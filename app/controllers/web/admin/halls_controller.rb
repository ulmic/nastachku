class Web::Admin::HallsController < Web::Admin::ApplicationController
  
  def index
    @halls = Hall.by_position
  end

  def new
    @hall = Hall.new
    @hall.slots.build
  end

  def edit
    @hall = Hall.find params[:id]
  end

  def create  
    @hall = Hall.new params[:hall]
    @hall.changed_by = current_user
    if @hall.save
      flash_success
      redirect_to edit_admin_hall_path(@hall)
    else
      flash_error
      render :new
    end
  end

  def update 
    @hall = Hall.find params[:id]
    @hall.changed_by = current_user
    if @hall.update_attributes params[:hall]
      flash_success
      redirect_to edit_admin_hall_path(@hall)
    else
      flash_error
      render :edit
    end
  end

  def destroy
    @hall = Hall.find params[:id]
    @hall.destroy
    redirect_to admin_halls_path
  end

end
