class RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new #build_resource({})
    @user.address = Address.new
  end

end
