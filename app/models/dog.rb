class Dog < ApplicationRecord
  has_many_attached :images
  scope :all_dogs_paginated, ->(records_per_page, page) { limit(records_per_page)
                                                          .offset((page - 1) * records_per_page) }
end
