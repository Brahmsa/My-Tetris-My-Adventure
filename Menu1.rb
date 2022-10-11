require 'gosu'

require_relative 'Start'
require_relative 'Credits'
require_relative 'HowToPlay'

class Menu1 < Gosu::Window 
	
	SCREEN_WIDTH = 650
	SCREEN_HEIGHT = 496
	
	def initialize
		super(SCREEN_HEIGHT, SCREEN_WIDTH, false)
		self.caption = 'My Tetris My Adventure'
		@background = Gosu::Image.new(self, "media/LatarBelakang.png")
		@start = Gosu::Image.new(self, "media/Startt.png")
		@how = Gosu::Image.new(self, "media/HowToPlay.png")
		@credits = Gosu::Image.new(self, "media/Creditss.png")
		@locs = [60,60]
		@text1 = Gosu::Image.from_text(self, "Version 1.1", "Algerian", 20)
	end
	
	def update
	#...
	end
	
	def mouse_start(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(300, 333)
	end
	
	def mouse_how(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(380, 413)
	end
	
	def mouse_credits(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(460, 493)
	end
	
	def button_down(id)
		case id
		when Gosu::MsLeft
			@locs = [mouse_x, mouse_y]
			if mouse_start(mouse_x, mouse_y)
				Start.new.show
			end
			if mouse_how(mouse_x, mouse_y)
				HowToPlay.new.show
			end
			if mouse_credits(mouse_x, mouse_y)
				Credits.new.show
			end
		end
	end
	
	def needs_cursor?
		true
	end
	
	def draw
		@background.draw(0,0,0)
		@start.draw(110,280,2)
		@how.draw(110,360,2)
		@credits.draw(110,440,2)
		@text1.draw(400,630,2)
	end
	
end
