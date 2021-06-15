class AddLeagueAppsToDivision < ActiveRecord::Migration[6.0]
  def change
    add_column :divisions, :league_apps_site_id, :integer
    add_column :divisions, :league_apps_program_id, :integer
  end
end
