class AddLeagueAppsToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :league_apps_game_id, :integer
  end
end
