require 'gosu'
#untuk memanggil library gosu

require_relative 'Start'
require_relative 'Credits'
require_relative 'HowToPlay'
#untuk memanggil file Start, Credits dan HowToPlay

class Menu < Gosu::Window 
	#class utama dalam file Menu
	
	SCREEN_WIDTH = 650
	SCREEN_HEIGHT = 496
	#untuk menentukan lebar dan tinggi dari layar game
	
	def initialize
		super(SCREEN_HEIGHT, SCREEN_WIDTH, false)
		self.caption = 'My Tetris My Adventure'
		#digunakan untuk memberikan judul pada window
		@background = Gosu::Image.new(self, "media/LatarBelakang.png")
		#digunakan untuk menambahkan gambar pada layar
		@start = Gosu::Image.new(self, "media/Startt.png")
		@how = Gosu::Image.new(self, "media/HowToPlay.png")
		@credits = Gosu::Image.new(self, "media/Creditss.png")
		@locs = [60,60]
		@text1 = Gosu::Image.from_text(self, "Version 1.1", "Algerian", 20)
	end
	#method initialize merupakan method utama dalam program yang digunakan untuk mendeklarasikan variabel,menginput gambar,judul dalam window dan lain sebagainya
	
	def mouse_start(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(280, 333)
	end
	#method mouse_start digunakan untuk menentukan lokasi dimana mouse akan diarahkan pada layar, ( x, y)
	
	def mouse_how(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(360, 413)
	end
	#method mouse_how digunakan untuk menentukan lokasi dimana mouse akan diarahkan pada layar, ( x, y)
	
	def mouse_credits(mouse_x, mouse_y)
		mouse_x.between?(110, 400) && mouse_y.between?(440, 493)
	end
	#method mouse_credits digunakan untuk menentukan lokasi dimana mouse akan diarahkan pada layar, ( x, y)
	
	def button_down(id)
		case id
		#percabangan menggunakan variabel id
		when Gosu::MsLeft
		#ketika mengklik kiri pada mouse
			@locs = [mouse_x, mouse_y]
			if mouse_start(mouse_x, mouse_y)
				Start.new.show
			end
			#jika method mouse_start dengn parameter mouse_x dan mouse_y maka akan memanggil class Start pada file Start
			if mouse_how(mouse_x, mouse_y)
				HowToPlay.new.show
			end
			#jika method mouse_how dengn parameter mouse_x dan mouse_y maka akan memanggil class HowToPlay pada file HowToPlay
			if mouse_credits(mouse_x, mouse_y)
				Credits.new.show
			end
			#jika method mouse_credits dengn parameter mouse_x dan mouse_y maka akan memanggil class Credits pada file Credits
		end
	end
	#method button_down digunakan sebagai fungsi tombol mouse pada program
	
	def needs_cursor?
		true
	end
	#digunakan untuk mengeluarkan pointer mouse pada layar
	
	def draw
		@background.draw(0,0,0)
		@start.draw(110,280,2)
		@how.draw(110,360,2)
		@credits.draw(110,440,2)
		@text1.draw(400,630,2)
	end
	#digunakan untuk memberikan lokasi pada gambar di layar, misal variabel start mengimport gambar pada folder media dan akan ditampilkan pada layar
	#lokasinya (x, y, z), maka x = 110, y=300, z=2
end

Main_Menu = Menu.new
Main_Menu.show
#digunakan untuk membuat objek baru dengan nama Main_Menu dari classs Menu dan memanggil objek dari Main_Menu