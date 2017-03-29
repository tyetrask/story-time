class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :check_policy, except: [:me]

  def index
    @users = User.all
  end

  def me
    @user = current_user
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params_with_settings)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

    def check_policy
      return true if current_user.is_admin
      redirect_to root_path, notice: 'You do not have permission to modify users.' if !@user || current_user.id != @user.id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :pivotal_api_token, :concentration_mode, :approved, :settings)
    end

    def user_params_with_settings
      user_params_clean = params[:user]
      # TODO: don't allow scary params for user.settings
      user_params_clean[:settings] = user_params_clean[:settings].symbolize_keys if user_params_clean[:settings]
      user_params_clean.symbolize_keys
    end
end
