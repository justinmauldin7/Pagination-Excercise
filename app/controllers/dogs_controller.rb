class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  # This before action ensures the @page variable is updated/calculating the right
  # page we are on, and is needed for the paginiation implementation to work correctly.
  before_action :set_page, only: [:index]

  # GET /dogs
  # GET /dogs.json
  def index
    get_all_dogs_paginated(dogs_per_page)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # This is the number of dogs we want to display on each page of the dog's index page.
  def dogs_per_page
    return 5
  end

  def get_all_dogs_paginated(dogs_per_page)
    all_dogs_count = Dog.all.size
    page_count = get_page_count(all_dogs_count, dogs_per_page)

    @number_of_dog_pages = create_number_of_pages_array(page_count)
  end

  # This method will return the number of pages there should be for each count of records.
  def get_page_count(count, records_per_page)
    (count / records_per_page.to_f).ceil
  end

  # This method will take the count of pages and create an array of numbers for each page.
  # (this array of numbers is needed to create the pagination page number buttons on views.)
  def create_number_of_pages_array(page_count)
    number_of_pages_array = []
    page_number = 1

    while number_of_pages_array.size < page_count do
      number_of_pages_array << page_number
      page_number += 1
    end

    return number_of_pages_array
  end

  # This method will always set/keep track of what page number you're on when your
  # clicking the pagination page number buttons.
  # (This is needed to ensure we get the right offset in our ActiveRecord queries.)
  def set_page
    if params[:page]
      @page = params[:page].to_i
    else
      @page = 1
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images)
  end
end
