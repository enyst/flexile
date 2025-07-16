# frozen_string_literal: true

class Api::V1::PeopleController < Api::V1::ApiController
  before_action :set_person, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @people = policy_scope(User)
    render json: @people
  end

  def show
    authorize @person
    render json: @person
  end

  def create
    @person = User.new(person_params)
    authorize @person

    if @person.save
      render json: @person, status: :created
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @person
    if @person.update(person_params)
      render json: @person
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @person
    @person.destroy
  end

  private

  def set_person
    @person = User.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :company_id)
  end
end
