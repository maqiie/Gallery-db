class Project < ApplicationRecord
    has_many_attached :images
  
    validates :title, presence: true
    validates :description, presence: true
  end
  