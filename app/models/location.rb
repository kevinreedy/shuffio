class Location < ApplicationRecord
  has_many :courts
  has_many :seasons
  has_many :teams
  has_many :touraments
  has_many :divisions, through: :seasons
end
