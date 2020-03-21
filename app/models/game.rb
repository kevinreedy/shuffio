class Game < ApplicationRecord
  belongs_to :match
  belongs_to :yellow_team, class_name: 'Team', optional: true
  belongs_to :black_team, class_name: 'Team', optional: true

  # TODO: validate this enum, and everything else
  enum game_type: { standard_singles: 0, standard_doubles: 1, palms_singles: 2, palms_doubles: 3 }

  validate :frames_or_points?
  validate :valid_game_number?
  validate :points_cannot_tie?

  after_initialize :default_values

  # TODO: reject frames with only one score, for example [[0, 0], [8, nil]]

  # TODO: re-work views to not need this method, probably in controller?
  def eight_frames
    return frames if frames.size == 8

    # '' actually has hidden unicode
    return frames.fill(['​', '​'], frames.length, 8 - frames.length) if frames.size < 8

    # else more than 8 frames, return last 8 if even, last 7 + padding if odd
    return frames.last(8) if frames.size.even?

    frames.fill(['​', '​'], frames.length, 1).last(8)
  end

  # TODO: re-work views to not need this method, probably in controller?
  def isa_frames
    return frames.fill(['​', '​'], frames.length, 9 - frames.length) if frames.size <= 8

    frames.fill(['​', '​'], frames.length, 17 - frames.length).drop(8)
  end

  def complete?
    return false unless frames # return quickly if frames is nil
    return false unless frames.size.positive?

    if max_frames && max_points
      # frame and point game, whichever comes first
      return false if (frames.count < max_frames) && (frames.last[0] < max_points) && (frames.last[1] < max_points)
    elsif max_frames
      # frame game
      return false if frames.count < max_frames # false if there are frames to go
    elsif max_points
      # point game
      return false if (frames.last[0] < max_points) && (frames.last[1] < max_points)
    end

    return false if (frames.last[0] == frames.last[1]) && !allow_ties # false if game tied and ties not allowed

    unless max_points
      return false unless at_game_end_boundary? # false if there are still frames remaining
    end

    true
  end

  def frame
    frames.count + 1
  end

  def next_hammer
    frame_count = frame

    case game_type
    when 'standard_singles'
      return 'yellow' if frames.count.odd?
      return 'black' if frames.count.even?
    when 'standard_doubles'
      case frame_count % 4
      when 1
        'black'
      when 2
        'black'
      when 3
        'yellow'
      when 0
        'yellow'
      end
    when 'palms_singles', 'palms_doubles'
      case frame_count % 4
      when 1
        'black'
      when 2
        'yellow'
      when 3
        'yellow'
      when 0
        'black'
      end
    else
      raise 'invalid game type'
    end
  end

  def game_end_boundary
    return 4 if standard_doubles?

    2
  end

  def at_game_end_boundary?
    return false if frames.count.zero?

    (frames.count % game_end_boundary).zero?
  end

  private

  def default_values
    self.frames ||= []
  end

  def frames_or_points?
    errors.add(:base, 'must have max_points or max_frames') unless max_points || max_frames
  end

  def valid_game_number?
    errors.add(:number, 'must be positive') unless number && number.positive?
  end

  def points_cannot_tie?
    errors.add(:base, 'point games cannot tie') if max_points && allow_ties
  end
end
