##The Classic Towers of Hanoi Game encapsulated in a class
class TowerOfHanoi
  ##Initializes variables and calls populate_tower_one
  def initialize tower_height
    @towers = [@tower_one = [], @tower_two = [], @tower_three = []]
    @tower_height = tower_height
    populate_tower_one tower_height
  end

   ##Populates first tower according to provided height
  def populate_tower_one tower_height
    tower_height.downto(1) do |height|
      @tower_one << Disk.new(height)
    end
  end

  ##Loops until game over. The loop-do loops until valid input is provided.
  def play
    display_welcome_message
    main_game_loop
    if game_over?
      puts "Congratulations, you won!"
      "WINNER"
    else
      "You quit the game."
    end
  end

  ##Main Game Loop
  def main_game_loop
    until game_over?
      from, to = nil, nil
      puts "These are your towers: "
      loop do
        render
        from = get_from
        break if from == "quit"    ##quits game if quit is entered
        to = get_to
        break if to == "quit"      ##quits game if quit is entered
        if possible_move?(from, to)
          move_disk(from, to)
          break
        else
          puts "You can't place the disk there, please try again."
        end
      end
      break if (from == "quit") || (to == "quit")      ##quits game if quit is entered
    end
  end

  ##Resets the game
  def reset
    @towers = [@tower_one = [], @tower_two = [], @tower_three = []]
    populate_tower_one @tower_height
    self.play
  end

  ##Displays Welcome Message
  def display_welcome_message
    puts "****************************************"
    puts "Welcome to the CLI Towers of Hanoi Game!"
    puts "****************************************\n"
  end

  ##Retrieves user input for destination of disk
  def get_to
    loop do
      puts "Where would you like to place it? "
      input = gets.chomp
      return input if input == "quit"
      return input.to_i if (1..3) === input.to_i
      puts "It's got to be a tower 1-3!"
    end
  end

  ##Retrieves user input for which disk to move
  def get_from
    loop do
      puts "From where would you like to remove a disk? "
      input = gets.chomp
      return input if input == "quit"
      if possible_from? input.to_i
        return input.to_i
      end
      puts "There are no disks there. Please try again."
    end
  end

  ##Checks if a given disk destination is feasible
  def possible_from? from
    @towers[from-1].any?
  end

  ##Checks for win condition
  def game_over?
    @tower_three.map{|disk| size_of_disk(disk)} == (1..@tower_height).to_a.reverse
  end

  ##Renders disks at command prompt using #'s
  def render
    return_string = ""
    (@tower_height).downto(1) do |height|
      1.upto(3) do |tower|
        disk = disk_at_height(tower, height)
        return_string += render_disk disk, (tower == 3)
      end
    end
    puts return_string
  end

  ##Renders a given disk at command prompt
  def render_disk disk, third
    if disk.nil?
      return_string = " " * (@tower_height+1)
    else
      return_string = disk.chars + (" " * ((@tower_height+1) - disk.size))
    end
    return_string += "\n" if third
    return_string
  end

  ##Moves a disk from one stack to another
  def move_disk from, to
    @towers[to-1] << @towers[from-1].pop
  end

  ##Checks to see if a given move is feasible
  def possible_move? from, to
    if top_disk_at(from).nil?
      return false
    elsif top_disk_at(to).nil?
      return true
    else
      size_of_disk(top_disk_at(from)) < size_of_disk(top_disk_at(to))
    end
  end

  ##Returns the top disk at a given tower
  def top_disk_at tower
    @towers[tower-1].last
  end

  ##Returns a given disk at a given tower and height
  def disk_at_height tower, height
    @towers[tower-1][height-1]
  end

  ##Returns the size of a given disk
  def size_of_disk disk
    disk.size
  end
end

##Disk class
class Disk
  attr_reader :size, :chars
  def initialize size
    @size = size
  end
  ##Returns a string of #'s according to disk size
  def chars
    "#" * @size
  end
end
