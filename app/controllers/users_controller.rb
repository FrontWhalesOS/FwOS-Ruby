class UsersController < ApplicationController

  def index
    @user = User.all
      render json: { user: @user.as_json(only: [:id, :full_name, :username, :email]) },
             status: :ok

  end



  def show
    @user = User.find(params[:user_id])
    render json: { user: @user.as_json(only: [:id, :full_name, :username,
                                              :email, :access_token]) }
  end

  def register
    passhash = Digest::SHA1.hexdigest(params[:password])
    @user = User.new(email: params[:email],
                     username: params[:username],
                     full_name: params[:full_name],
                     password: passhash)
    if @user.save
      # render json "register.json.jbuilder", status: :created
      render json: { user: @user.as_json(only: [:id, :username, :email, :access_token]) },
        status: :created
    else
      render json: { errors: @user.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def login
    passhash = Digest::SHA1.hexdigest(params[:password])
    @user = User.find_by(username: params[:username], password: passhash)

    if @user
      # render json "register.json.jbuilder", status: :created
      render json: { user: @user.as_json(only: [:id, :full_name, :username,
                                                :email, :access_token]) },
             status: :ok
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
      end
    end
end