
# p data
# # new line denoted by \n\n


# new char denoted by full verticle line of whitespace

class CharacterIsolater
  attr_reader :raw_data, :horizontals, :verticles, :grid, :depth,
              :width, :perceived_white_space, :white_space_indexes

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def call
    get_horizontals
    get_grid
    get_verticles
    get_white_space_indexes
    character_grids
  end

  private
  def get_horizontals
    @horizontals = raw_data.split("\n")
  end

  def get_grid
    @grid = horizontals.map { |h| h.split('') }.reject { |h| h.empty? }
  end

  def get_verticles
    @depth = grid.length
    @width = grid.map { |l| l.length }.sort.reverse.first
    @perceived_white_space = ' ' * depth
    verticles = []
    width.times do |i|
      str = ''
      width.times do |j|
        str += (grid[j][i] || '') if grid[j]
      end
      verticles.push str
    end

    @verticles = verticles
  end

  def get_white_space_indexes

    @white_space_indexes = verticles
      .each_with_index
      .map { |v, i| i if v === perceived_white_space }
      .reject { |i| i.nil?} << width # remember to add EOL index
  end

  def character_grids

    white_space_indexes
      .each_with_index
      .map do |w_s_index, i|
        arr = []
        depth.times do |j|
          limit = i == 0 ? 0 : white_space_indexes[i-1]

          arr.push(grid[j][limit..w_s_index])
        end
        arr
      end
  end
end

file = File.open('config_sequence.txt')

data = file.read

character_grids = CharacterIsolater.new(data).call

num_map = {}

character_grids
  .each_with_index {|char, i| num_map[char] = i }

character_grids2 = CharacterIsolater.new(data).call

character_grids2.each {|c| puts num_map[c]}

file.close
