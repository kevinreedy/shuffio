class AddParamToTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :param_name, :string
  end
end
