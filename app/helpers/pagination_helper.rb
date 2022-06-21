module PaginationHelper
  # This is the number of dogs we want to display on each page of the dog's index page.
  def dogs_per_page
    return 5
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

  # This method sets all the instance variables that are needed when showing all
  # the dogs paginated into smaller chunks/pages.
  def get_all_dogs_paginated(dogs_per_page)
    all_dogs_count = Dog.all.size
    page_count = get_page_count(all_dogs_count, dogs_per_page)

    @number_of_dog_pages = create_number_of_pages_array(page_count)
    # This query will get the number of dogs set by the
    # "dogs_per_page" variable, and keeps loading that number of dogs
    # on the page getting the next set of dogs each time.
    @dogs = Dog.all_dogs_paginated(dogs_per_page, @page)
  end

  private

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
end
