namespace :team do
  desc 'Add param_name to existing teams'
  task param_name: :environment do
    Team.where(param_name: nil).each do |t|
      t.update(param_name: Team.param_name(t.name))
    end
  end
end
