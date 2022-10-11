require 'gosu'
#digunakan untuk memanggil library gosu pada program

require_relative 'level2'
require_relative 'level3'
require_relative 'menu1'
#digunakan untuk memanggil file level2 dan level3

class Start < Gosu::Window
	#class utama dalam file Start
	
	SCREEN_WIDTH = 650
	SCREEN_HEIGHT = 496
	#untuk menentukan lebar dan tinggi dari layar game
	
	def initialize
		super(SCREEN_HEIGHT, SCREEN_WIDTH, false)
		self.caption = 'My Tetris My Adventur : Difficult'
		@background = Gosu::Image.new(self, "media/LatarBelakang.png")
		@normal = Gosu::Image.new(self, "media/Normal.png")
		@hard = Gosu::Image.new(self, "media/Hard.png")
		@text1 = Gosu::Image.from_text(self, "Version 1.1", "Algerian", 20)
	end
	#method initialize merupakan method utama dalam program yang digunakan untuk mendeklarasikan variabel,menginput gambar, memberikan judul dalam window dan lain sebagainya
	
	def mouse_normal(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(280, 333)
	end
	#method mouse_normal digunakan untuk menentukan lokasi dimana mouse akan diarahkan pada layar, ( x, y)
	
	def mouse_susah(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(380, 433)
	end
	#method mouse_susah digunakan untuk menentukan lokasi dimana mouse akan diarahkan pada layar, ( x, y)
	
	def update
		if (button_down?(Gosu::KbEscape))
			Menu1.new.show
		end
	end
	#method update digunakan untuk membuat kembali ke Main Menu dengan cara memanggil class Menu1 jika pengguna tekan escape
	def button_down(id)
		case id
		#percabangan menggunakan variabel id
		when Gosu::MsLeft
		#ketika mengklik kiri pada mouse
			@locs = [mouse_x, mouse_y]
			if mouse_normal(mouse_x, mouse_y)
				LevelNormal.new.show
			end
			#jika method mouse_normal dengn parameter mouse_x dan mouse_y maka akan memanggil class LevelNormal pada file level1
			if mouse_susah(mouse_x, mouse_y)
				LevelHard.new.show
			end
			#jika method mouse_susah dengn parameter mouse_x dan mouse_y maka akan memanggil class LevelHard pada file level2
		end
	end
	
	def needs_cursor?
		true
	end
	#digunakan untuk mengeluarkan pointer mouse pada layar
	
	def draw
		@background.draw(0,0,0)
		@normal.draw(110,280,2)
		@hard.draw(110,380,2)
		@text1.draw(400,630,2)
	end
	
end