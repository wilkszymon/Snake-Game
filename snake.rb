require 'ruby2d'

set title: "Snake-Game"
set background: 'navy'
set fps_cap: 10



PIXEL_SIZE = 20
GRID_WIDTH = Window.width / PIXEL_SIZE
GRID_HEIGHT = Window.height / PIXEL_SIZE

class Snake

    attr_writer :direction

    def initialize
        @positions = [[5,0],[5,1],[5,2], [5,3]]
        @direction = 'down'
        @growing = false
    end

    def draw_positions
        @positions.each do |position|
            Square.new(x: position[0]*PIXEL_SIZE, y: position[1]*PIXEL_SIZE , color:'white', size:PIXEL_SIZE - 1)
        end
    end

    def move_snake
        if !@growing
            @positions.shift
        end
        case @direction
        when 'down'
            @positions.push(coords(head[0], head[1] + 1))
        
        when 'up'
            @positions.push(coords(head[0], head[1] - 1))
        
        when 'left'
            @positions.push(coords(head[0] - 1, head[1]))
        
        when 'right'
            @positions.push(coords(head[0] + 1, head[1]))
        end
        @growing = false
    end

    def can_change_direction?(key)
        case @direction
            when 'up' then key != 'down'
            when 'down' then key != 'up'
            when 'right' then key != 'left'
            when 'left' then key != 'right'
        end
    end

    def hit?
        @positions.uniq.length != @positions.length
    end

    def grow
        @growing = true
    end

    def x
        head[0]
    end

    def y
        head[1]
    end

    private

    def coords(x,y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
    end


    def head
        @positions.last
    end

end

class Game
    def initialize 
        @score = 0
        @ball_x = rand(GRID_WIDTH)
        @ball_y = rand(GRID_HEIGHT)
        @finish = false
    end

    def draw_positions
            Square.new(x: @ball_x*PIXEL_SIZE, y: @ball_y*PIXEL_SIZE , color:'red', size:PIXEL_SIZE)
            Text.new(text_mess, x: 10, y: 10, size: 20, color:"green")
    end

    def snake_eat_ball?(x,y)
        @ball_x == x && @ball_y == y
    end

    def record_hit
        @score += 1
        @ball_x = rand(GRID_WIDTH)
        @ball_y = rand(GRID_HEIGHT)
    end

    def finish_game
        @finish = true
    end

    def finished?
        @finish
    end

    def text_mess
        if finished?
            "Game over, you score was #{@score}. Press to 'R' to restart."
        else
            "Your score: #{@score}"
        end
    end

end

snake = Snake.new
game = Game.new


update do
    clear 

    unless game.finished?
        snake.move_snake
    end
    snake.draw_positions
    game.draw_positions

    if game.snake_eat_ball?(snake.x, snake.y)
        game.record_hit
        snake.grow
    end
    if snake.hit?
        game.finish_game
    end
end

on :key_down do |e|
    if ['up', 'down', 'right', 'left'].include?(e.key)
        if snake.can_change_direction?(e.key)
        snake.direction = e.key
        end
    elsif e.key == 'r' || e.key == 'R'
        snake = Snake.new
        game = Game.new
    end
end



show
