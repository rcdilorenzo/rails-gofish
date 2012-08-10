class RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new #build_resource({})
    @user.addresses << Address.new
    @user = resource
    respond_with resource
  end
end
