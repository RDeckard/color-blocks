# frozen_string_literal: true

# SETTINGS
X = 100
Y = 100

COLORS = %w[R G B].freeze

# DATA STRUCTURES
TILES =
  X.times.map do
    Y.times.map do
      { color: COLORS.sample, group_id: nil }
    end.freeze
  end.freeze

COUNTS_BY_GROUP_ID = Hash.new(1)

# EXPLORATION ALGORITHM
explore =
  lambda do |x, y, origin_point_color, current_group_id|
    ((x - 1)..(x + 1)).map do |i|
      next if i.negative? || i >= X

      ((y - 1)..(y + 1)).map do |j|
        next if j.negative? || j >= Y
        next unless (i == x) ^ (j == y)

        TILES[i][j] in { color: target_point_color, group_id: target_point_group_id }
        next unless target_point_group_id.nil?

        next unless target_point_color == origin_point_color

        TILES[i][j][:group_id] = format('%05<group_nb>d', group_nb: current_group_id)
        COUNTS_BY_GROUP_ID[format('%05<group_nb>d', group_nb: current_group_id)] += 1

        explore.call(i, j, origin_point_color, current_group_id)
      end
    end
  end

# PROGRAM
puts 'DATA:'
TILES.each(&method(:p))

current_group_id = 1

(0..(X - 1)).map do |x|
  (0..(Y - 1)).map do |y|
    TILES[x][y] in { color: origin_point_color, group_id: origin_point_group_id }
    next unless origin_point_group_id.nil?

    TILES[x][y][:group_id] = format('%05<group_nb>d', group_nb: current_group_id)

    explore.call(x, y, origin_point_color, current_group_id)

    current_group_id += 1
  end
end

puts "\nRESULT:"
TILES.each(&method(:p))

puts "\nCOUNTS BY GROUP_ID:"
p(COUNTS_BY_GROUP_ID.sort_by { _2 }.to_h)
