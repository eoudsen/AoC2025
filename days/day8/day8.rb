require 'csv'
require 'set'

class Point
  attr_accessor :id, :x, :y, :z, :connections

  def initialize(id, x, y, z)
    @id = id
    @x = x
    @y = y
    @z = z
    @connections = Set.new
  end

  def distance(other)
    Math.sqrt((@x - other.x)**2 + (@y - other.y)**2 + (@z - other.z)**2)
  end

  def to_s
    "Point ID: #{@id}, Coordinates: (#{@x}, #{@y}, #{@z})"
  end
end

class Group
  attr_accessor :points

  def initialize
    @points = Set.new
  end

  def add_point(point)
    @points.add(point)
  end

  def size
    @points.size
  end

  def hash
    @points.map(&:id).sort.hash
  end

  def eql?(other)
    other.is_a?(Group) && @points.map(&:id).sort == other.points.map(&:id).sort
  end
end

class PointManager
  attr_accessor :points, :num_closest_connections

  def initialize(num_closest_connections)
    @points = []
    @num_closest_connections = num_closest_connections
  end

  def load_points(file_path)
    CSV.foreach(file_path, headers: false) do |row|
      id = @points.length + 1
      x, y, z = row.map(&:to_i)
      @points << Point.new(id, x, y, z)
    end
  end

  def connect_points
    distances = []

    @points.combination(2) do |point1, point2|
      distances << [point1, point2, point1.distance(point2)]
    end

    distances.sort_by! { |_, _, dist| dist }
    connected_pairs = Set.new
    distances.first(@num_closest_connections).each do |point1, point2, _|
      next if connected_pairs.include?([point1.id, point2.id]) || connected_pairs.include?([point2.id, point1.id])
      point1.connections.add(point2.id)
      point2.connections.add(point1.id)
      connected_pairs.add([point1.id, point2.id])
    end
  end

  def find_groups
    visited = Set.new
    groups = []

    @points.each do |point|
      next if visited.include?(point.id)

      group = Group.new
      queue = [point]

      until queue.empty?
        current = queue.pop
        visited.add(current.id)
        group.add_point(current)

        current.connections.each do |connected_id|
          next if visited.include?(connected_id)

          connected_point = @points.find { |p| p.id == connected_id }
          queue.push(connected_point) if connected_point
        end
      end

      groups << group unless group.size.zero?
    end

    groups
  end

  def calculate_top_groups_product(groups)
    sizes = groups.map(&:size).sort.reverse.first(3)
    sizes.inject(:*) || 1
  end

  def find_connections_to_connect_all
    distances = []

    @points.combination(2) do |point1, point2|
      distances << [point1, point2, point1.distance(point2)]
    end

    distances.sort_by! { |_, _, dist| dist }
    connected_ids = Set.new
    first_point = Point.new(0, 0, 0, 0)
    second_point = Point.new(0, 0, 0, 0)

    connected_ids.add(@points.first.id)

    until connected_ids.size == @points.size
      found_connection = false

      distances.each do |point1, point2, _|
        if connected_ids.include?(point1.id) && !connected_ids.include?(point2.id)
          point1.connections.add(point2.id)
          point2.connections.add(point1.id)
          first_point = point1
          second_point = point2
          connected_ids.add(point2.id)
          found_connection = true
          break
        elsif connected_ids.include?(point2.id) && !connected_ids.include?(point1.id)
          point2.connections.add(point1.id)
          point1.connections.add(point2.id)
          first_point = point1
          second_point = point2
          connected_ids.add(point1.id)
          found_connection = true
          break
        end
      end

      break unless found_connection
    end

    first_point.x * second_point.x
  end
end

def main
  num_closest_connections = 1000
  point_manager = PointManager.new(num_closest_connections)
  point_manager.load_points('input.txt')
  point_manager.connect_points
  groups = point_manager.find_groups
  product = point_manager.calculate_top_groups_product(groups)
  puts "part1: #{product}"

  connections_needed = point_manager.find_connections_to_connect_all
  puts "part2: #{connections_needed}"
end

main
