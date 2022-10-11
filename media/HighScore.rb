require 'gosu'
#digunakan untuk memanggil library gosu

#digunakan untuk memanggil file atau menghubungkan file Menu1
class HighScore < Gosu::Window
#class utama dalam file Menu

	SCREEN_WIDTH = 650
	SCREEN_HEIGHT = 496
	#untuk menentukan lebar dan tinggi dari layar game
	
	def initialize
		super(SCREEN_HEIGHT, SCREEN_WIDTH, false)
		self.caption = 'My Tetris My Adventure : High Score'
		@background = Gosu::Image.new(self, "media/LatarBelakang.png")
		@text1 = Gosu::Image.from_text(self, "Version 1.1", "Algerian", 20)
	end
	#method initialize merupakan method utama dalam program yang digunakan untuk mendeklarasikan variabel,menginput gambar,judul dalam window dan lain sebagainya
	
	def needs_cursor?
		true
	end
	#digunakan untuk mengeluarkan pointer mouse pada layar
	
	def button_down(id)
		if id == Gosu::KbEscape
			Menu1.new.show
			#digunakamn jika pengguna menekan tombol escape maka akan memanggil class Menu1
		end
	end
	def draw
		@background.draw(0,0,0)
		@text1.draw(400,630,2)
	end
	#digunakan untuk menampilkan gambar sesuai dengan lokasi yang telah ditentukann
end

HighScore.new.show