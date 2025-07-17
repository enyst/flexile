# frozen_string_literal: true

class Api::V1::PeopleController < Api::V1::ApiController
  before_action :set_person, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @people = policy_scope(User)
    render json: UserPresenter.new(@people).present
  end

  def show
    authorize @person
    render json: UserPresenter.new(@person).present
  end

  def create
    authorize User
    @person = User.new(person_params)

    if @person.save
      render json: UserPresenter.new(@person).present, status: :created
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @person
    if @person.update(person_params)
      render json: UserPresenter.new(@person).present
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @person
    @person.destroy
    head :no_content
  end

  private

  def set_person
    @person = User.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :company_id)
  end
end
