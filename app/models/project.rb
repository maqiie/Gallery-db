class Project < ApplicationRecord
    has_many_attached :images
    has_many_attached :media

    validates :title, presence: true
    validates :description, presence: true
  end
  