class UsersController<ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:logged_in] = "You have successfully registered and logged in."
      redirect_to '/profile'
    else
      flash[:invalid_information] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    render file: '/public/404' unless current_user
  end

  def edit

  end

  def orders
    @orders = Order.all
  end

  def update
    if current_user.update(user_params)
      flash[:update] = 'Data has been updated'
      redirect_to('/profile')
    else
      flash[:invalid_information] = @user.errors.full_messages.uniq.to_sentence
      render :edit
    end
  end

  def edit_password

  end

  def update_password
    if current_user.update(user_params)
      flash[:password_update] = 'Password has been updated'
      redirect_to('/profile')
    else
      flash[:invalid_information] = @user.errors.full_messages.uniq.to_sentence
      render :edit_password
    end
  end

  private
  def user_params
    params.permit(
      :name,
      :address,
      :city,
      :state,
      :zip,
      :email,
      :password,
      :password_confirmation
    )
  end


end
