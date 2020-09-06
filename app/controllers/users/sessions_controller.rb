# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  def new
    @user = User.new
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end
  def create
    @user = User.new(sign_in_params)
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
    session[:keep_signed_out] = true
  end


  protected

  # def user_params
  #   params.require(:identifications).permit(:family_name_kanji, :first_name_kanji, :family_name_kana, :first_name_kana,
  #                                           :birthday, :postal_code, :prefecture, :city, :address1, :address2, :telephone)
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
