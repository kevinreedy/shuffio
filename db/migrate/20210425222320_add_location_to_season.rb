class AddLocationToSeason < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :seasons, :location
  end
end
