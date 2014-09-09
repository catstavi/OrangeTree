class OrangeGrove
  attr_accessor :trees, :soil_quality
  #1 is healthy soil, 2 is average and 3 is unhealthy
  def initialize()
    @trees = []
    @soil_quality = 1
    @soil_hash = {1 => ",,", 2 => "..", 3 => "__"}
    @tree_hash = {:new_old => "_l_", :healthy => "<|>", :dead => "_!_"}
  end

  def create_grove(number_of_trees, height_base)
    number_of_trees.times do |i|
      add_tree(height_base)
    end
  end

  def add_tree(height_base)
    @trees << OrangeTree.new(height_base)
  end

  def one_year_passes
    @trees.each do |tree|
      tree.one_year_passes
      tree.orange_rate *= @soil_quality
      tree.max_age += @soil_quality
    end
  end

  def years_pass(years)
    years.times do one_year_passes
    end
  end

  def count_all_oranges
    count = 0
    @trees.each do |tree|
      count += tree.orange_count
    end
    puts "#{count} oranges total."
  end

  def border
    21.times { print '-' }
    puts
  end

  def display_oranges(start_index, end_index)
    @trees[start_index..end_index].each do |tree|
      print "   #{tree.orange_count}   "
    end
    puts
  end

  def display_tree(start_index, end_index)
    @trees[start_index..end_index].each do |tree|
      tree_pic = @tree_hash[tree.status]
      soil_pic = @soil_hash[@soil_quality]
      print "#{soil_pic}#{tree_pic}#{soil_pic}"
    end
    puts
  end

  def display
    rows = @trees.length / 3 + 1
    #puts "Tree length: #{@trees.length}"
    #puts "Rows: #{rows}"
    start_index = 0
    end_index = 2
    rows.times do
      #puts start_index
      #puts end_index
      border
      display_oranges(start_index, end_index)
      display_tree(start_index, end_index)
      start_index += 3
      end_index += 3
      if end_index > (trees.length - 1)
        end_index = trees.length - 1
      end
      if start_index > (trees.length - 1)
        start_index = trees.length
      end
    end
    border
  end

end


class OrangeTree
  attr_accessor :height, :age, :orange_count, :orange_rate, :status, :max_age

  def initialize(height_base, status = :new_old)
    @age = 0
    @height = @height_base = height_base
    @orange_rate = 3
    @orange_count = 0
    @status = status
    @max_age = 15
    #@status_set = [:healthy, :new_old, :dead]
  end

  def self.plant_on(grove, height_base)
    death_num = rand(10)
    status = :new_old
    if grove.soil_quality == 3 && death_num > 3
        status = :dead
    elsif grove.soil_quality == 2 && death_num > 7
        status = :dead
    else
      print "Your tree is healthy!"
    end
    grove.trees << new(height_base, status)
    num_trees = grove.trees.length
    if num_trees > 7
      grove.soil_quality = 3
    elsif num_trees > 3
      grove.soil_quality = 2
    end
  end

  def one_year_passes
    @age += 1
    unless @status == :dead
      @height = @age * @height_base
      if @max_age == @age
        @status = :new_old
      elsif @age > @max_age
        @status = :dead
      elsif @status == :new_old
        @status = :healthy
      else
        @orange_count = orange_rate
        @max_age = 15
        @orange_rate = 3
      end
    end
  end

  def years_pass(years)
    years.times do one_year_passes
    end
  end

  def measure_tree
    puts "You tree is #{@height} units of measurement tall!"
  end

  def count_the_oranges
    puts "There are #{orange_count} oranges on the tree!"
  end

  def pick_orange
    if @orange_count > 0
      @orange_count -= 1
      puts "It is flavorful and orange! Just like you like your oranges! Yum!"
    else
      puts "Your tree is orange-less. Better wait until it grows some more."
    end
  end
end
