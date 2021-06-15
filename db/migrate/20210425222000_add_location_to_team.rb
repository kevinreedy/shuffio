class AddLocationToTeam < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :teams, :location
  end
end
