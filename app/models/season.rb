class Season < ApplicationRecord
  has_many :divisions
  has_many :teams, through: :divisions
  has_many :matches, through: :divisions
  belongs_to :champion, class_name: 'Team', optional: true
  belongs_to :location

  def latest?
    Season.order(:start_date).last == self
  end

  def started?
    start_date.past?
  end

  def export_summary
    require 'csv'

    attributes = %w[
      id
      time
      court
      division
      comment
      home_team
      away_team
      winner
      home_score
      away_score
      home_old_elo
      home_new_elo
      away_old_elo
      away_new_elo
    ]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      matches.order(:time, :id).each do |m|
        csv << m.export_summary
      end
    end
  end

  def self.latest
    Season.order(:start_date).last
  end
end
