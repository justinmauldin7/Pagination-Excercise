class Dog < ApplicationRecord
  has_many_attached :images
  # This scoped method will return the correct chunk of dog records depending on
  # the page & number of records to display per page we pass to this ActiveRecord query.
  scope :all_dogs_paginated, ->(records_per_page, page) { limit(records_per_page)
                                                          .offset((page - 1) * records_per_page) }
end
