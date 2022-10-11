require 'gosu'
#digunakan untuk memanggil library gosu

require_relative 'Menu1'
#digunakan untuk memanggil file Menu1

class Block
	#class blok digunakan sebagai method yang bertugas untuk  membuat blok dari tetris
  attr_accessor :falling
  attr_accessor :x, :y, :width, :height, :color
  
  updateInterval = 0
  @@image = nil
  
  def initialize(game)
  	if @@image == nil
		@@image = Gosu::Image.new(game, "block.png", false) 
	end
	#gambar blok hanya akan dikeluarkan hanya sekali pada semua blok
	
	@level = 0
	@x = 0
	@y = 0
	@width  = @@image.width;
	@height = @@image.height
	@game = game
	@color = 0xffffffff
	#pada method ini juga mendeklarasikan variabel yang akan digunakan pada class blok
  end
  
  def draw
    @@image.draw(@x, @y, 0, 1, 1, @color)
  end
  
  def collide(block)
    return (block.x == @x && block.y == @y)
  end
  #method collide akan berjalan jika 2 blok saling bertabrakan ketika pada posisi yang sama
  
  def collide_with_other_blocks
    @game.blocks.each do |block|
      if collide(block)
	    return block
	  end
	end
    nil
  end
end

class Shape
  attr_accessor :rotation
  def initialize(game)
    @game = game
    @last_fall_update = Gosu::milliseconds 
    @last_move_update = Gosu::milliseconds 
	
	@blocks = [Block.new(game), Block.new(game), Block.new(game), Block.new(game) ]

	@x = @y = 0
	@falling = true
	@rotation_block = @blocks[1]
	@rotation_cycle = 1
	@rotation = 0
  end
  #method diatas merupakan method shape yang digunakan sebagai pengatur bentuk dari setiap - setiap blok
  
  def apply_rotation
  #method ini digunakan untuk membuat objek dari bloknya dapat memutar 90 derajat searah jarum jam
    if @rotation_block != nil
		(1..@rotation.modulo(@rotation_cycle)).each do |i|
		  @blocks.each do |block|
			old_x = block.x
			old_y = block.y
			block.x = @rotation_block.x + (@rotation_block.y - old_y)
			block.y = @rotation_block.y - (@rotation_block.x - old_x)
		  end
		end
    end
  end
  
  def reverse
  #digunakan untuk memutar bentuk balok berdasarkan y axis, contoh seperti bentuk L dan J
    center = (get_bounds[2] + get_bounds[0]) / 2.0
    @blocks.each do |block|
	  block.x = 2*center - block.x - @game.block_width
	end
  end
  
  def get_bounds
    x_min = []
	y_min = []
	x_max = []
	y_max = []
    @blocks.each do |block| 
	  x_min << block.x
	  y_min << block.y
	  
	  x_max << block.x + block.width
	  y_max << block.y + block.height
	end

	return [x_min.min, y_min.min, x_max.max, y_max.max]
  end
  
  def needs_fall_update?
	updateInterval = 0
	@level = 1
    if ( @game.button_down?(Gosu::KbDown) )
      updateInterval = 100
	else
	  updateInterval = 500 - @game.level*70
	end
	if ( Gosu::milliseconds - @last_fall_update > updateInterval )
      @last_fall_update = Gosu::milliseconds 
	end
  end
  #method needs_fall_update digunakan untuk membuat balok turun dari atas,
  #jika pengguna menekan tombol arah panah ke bawah pada keyboard, maka balok akan turun dengan interval 100
  #sedangkan jika pengguna tidak menekan tombol maka interval jatuh akan 500 - game.level*70
  
  def needs_move_update?
	if ( Gosu::milliseconds - @last_move_update > 100 )
	  @last_move_update = Gosu::milliseconds 
    end
  end
  #Gosu::milliseconds merupakan fungsi yang digunakan untuk membuat waktu dengan rentang milidetik
  
  def draw
    get_blocks.each { |block| block.draw }
  end
  #digunakan untuk menampilkan blok pada layar
  
  def update
    if ( @falling ) 
	  old_x = @x
	  old_y = @y
	  
	  if needs_fall_update?
		@y = (@y + @game.block_height)
	  end
	  
	  if ( collide )
	    @y = (old_y)
		@falling = false
		@game.spawn_next_shape
		@game.delete_lines_of(self)
	  else  
	    if needs_move_update?
		  if (@game.button_down?(Gosu::KbLeft))
		    @x =  (@x - @game.block_width)
		  end
		  if (@game.button_down?(Gosu::KbRight))
			@x = ( @x + @game.block_width)
		  end
		#fungsi if diatas digunakan untuk menggerakan objek balok ke arah kiri atau kanan
		  
		  if ( collide )
		    @x = (old_x)
		  end 
		end  
	  end
	end
  end
  #method ini digunakan jika setelah blok jatuh atau melakukan pergerakan, maka method ini akan mengecek apakah
  #ada blok dari tetris akan bertabrakan dengan batas layar kiri atau kanan, jika iya maka akan dikembalikan ke posisi terakhir  
  
  def collide
    get_blocks.each do |block|
	  collision = block.collide_with_other_blocks;
	  if (collision)
	    return true
	  end
    end

    bounds = get_bounds
  
    if ( bounds[3] > @game.height )
	  return true
    end
  
    if ( bounds[2] > @game.width )
	  return true
    end
  
    if ( bounds[0] < 0 )
	  return true
    end	
    return false
  end
  
end
#digunakan untuk objek balok yang saling bertuabrakan antara satu dengan yang lainnya

class ShapeI < Shape
  def initialize(game)
    super(game)
	
	@rotation_block = @blocks[1]
	@rotation_cycle = 2
  end
  
  def get_blocks    
	@blocks[0].x = @x
	@blocks[1].x = @x
	@blocks[2].x = @x
	@blocks[3].x = @x
	@blocks[0].y = @y
  	@blocks[1].y = @blocks[0].y + @blocks[0].height
	@blocks[2].y = @blocks[1].y + @blocks[1].height
	@blocks[3].y = @blocks[2].y + @blocks[2].height
	
	apply_rotation
	
	@blocks.each { |block| block.color = 0xffb2ffff }
  end
end
#method ShapeI digunakan untuk membuat objek I dengan warna cyan(biru muda)

class ShapeL < Shape
  def initialize(game)
    super(game)
	
	@rotation_block = @blocks[1]
	@rotation_cycle = 4
  end
  
  def get_blocks	
	@blocks[0].x = @x
	@blocks[1].x = @x
	@blocks[2].x = @x
	@blocks[3].x = @x + @game.block_width
	@blocks[0].y = @y
  	@blocks[1].y = @blocks[0].y + @game.block_height
	@blocks[2].y = @blocks[1].y + @game.block_height
	@blocks[3].y = @blocks[2].y
	
	apply_rotation
	
	@blocks.each { |block| block.color = 0xffff7f00 }
  end
end
#method ShapeL digunakan untuk membuat objek L dengan warna orange

class ShapeJ < ShapeL
  def get_blocks
    old_rotation = @rotation
    @rotation = 0  
	
    super
	reverse
	
	@rotation = old_rotation
	apply_rotation
	
	@blocks.each { |block| block.color = 0xff0000ff}
  end
end
#method ShapeJ digunakan untuk membuat objek J dengan warna biru tua
#pada method ini menggunakan method pada ShapeL hanya saja di balik

class ShapeCube < Shape
  def get_blocks
	@blocks[0].x = @x
	@blocks[1].x = @x
	@blocks[2].x = @x + @game.block_width
	@blocks[3].x = @x + @game.block_width
	@blocks[0].y = @y
  	@blocks[1].y = @blocks[0].y + @game.block_height
	@blocks[2].y = @blocks[0].y 
	@blocks[3].y = @blocks[2].y + @game.block_height
	
	@blocks.each { |block| block.color = 0xffffff00}
  end
end
#method ShapeCube digunakan untuk membuat objek kotak dengan warna kuning

class ShapeZ < Shape
  def initialize(game)
    super(game)
	
	@rotation_block = @blocks[1]
	@rotation_cycle = 2
  end
  
  def get_blocks
	@blocks[0].x = @x
	@blocks[1].x = @x + @game.block_width
	@blocks[2].x = @x + @game.block_width
	@blocks[3].x = @x + @game.block_width*2
	@blocks[0].y = @y
  	@blocks[1].y = @y
	@blocks[2].y = @y + @game.block_height
	@blocks[3].y = @y + @game.block_height
	
	apply_rotation
	@blocks.each { |block| block.color = 0xffff0000}
  end
end
#method ShapeZ digunakan untuk membuat objek Z dengan warna merah

class ShapeS < ShapeZ
  def get_blocks
    old_rotation = @rotation
    @rotation = 0  
	
    super
	reverse
	
	@rotation = old_rotation
	apply_rotation
	
	@blocks.each { |block| block.color = 0xff00ff00}
  end
end
#method ShapeS digunakan untuk membuat objek S dengan warna hijau

class ShapeT < Shape
  def initialize(game)
    super(game)
	
	@rotation_block = @blocks[1]
	@rotation_cycle = 4
  end
  
  def get_blocks	
	@blocks[0].x = @x
	@blocks[1].x = @x + @game.block_width
	@blocks[2].x = @x + @game.block_width*2
	@blocks[3].x = @x + @game.block_width
	@blocks[0].y = @y
  	@blocks[1].y = @y
	@blocks[2].y = @y
	@blocks[3].y = @y + @game.block_height
	
	apply_rotation
	@blocks.each { |block| block.color = 0xffff00ff}
  end
end
#method ShapeT digunakan untuk membuat objek T dengan warna ungu

class LevelNormal< Gosu::Window
#class LevelNormal merupakan class utama dalam file level2

  attr_accessor :blocks
  attr_reader :block_height, :block_width
  attr_accessor :level
  attr_reader :falling_shape
 #attr_accessor digunakan untuk variabel agar dapat di read and write pada class lain
 
  STATE_PLAY = 1
  STATE_GAMEOVER = 2
  GAME_LENGTH = 100
  HIT_SCORE = 100
  #variabel global pada class LevelNormal
  
  def initialize
    super(480, 680, false)
	@text3 = Gosu::Font.new(self, "Arial", 25)
	#digunakan untuk membuat tulisan dengan nama variabel text3 dengan ukuran text 25 dan font 25
	@text4 = Gosu::Image.from_text(self, "Score :" ,"Arial", 25)
	#digunakan untuk membuat tulisan dengan nama variabel text4 dengan ukuran text 25, font 25 dengan isi Score
	@text5 = Gosu::Image.from_text(self, "Line  : ", "Arial", 25)
	@text6 = Gosu::Font.new(self, "Arial", 25)
	@block_width = 32
	@block_height = 32
	@gambar = Gosu::Image.new(self, "media/yuk.png")
	@gambar2 = Gosu::Image.new(self, "media/yuk.png")
	
	
	@blocks = []
	@state = STATE_PLAY
	@start_time = 0
	spawn_next_shape
	@hit = 0
	@score = 0
	@lines_cleared = 0
	@level = 1
	
	self.caption = "My Tetris My Adventure"
	@song = Gosu::Song.new("TetrisB_8bit.ogg")
  end
  #method diatas digunakan untuk mendeklarasikan variabel dan menginput gambar, menuliskan text  
  
  def update
    if ( @state == STATE_PLAY )
      if ( @falling_shape.collide )
        @state = STATE_GAMEOVER 
		#jika balok saling bertabrakan sampai atas layar, maka state = STATE_GAMEOVER atau akan game over
	  else
        @falling_shape.update
		#jika tidak maka akan terus mengeluarkna balok
	  end
	  @level = 0
	  self.caption = "My Tetris My Adventure : Normal"
	else 
	  if ( button_down?(Gosu::KbSpace))
		@falling_shape = nil
		@level = 0
		@lines_cleared = 0
		spawn_next_shape
		@state = STATE_PLAY
		@score = 0
		@blocks = []
		#digunakan jika pengguna menekan tombol spasi pada saat game over, maka game akan memulai dari awal lagi
		end
	  if ( button_down?(Gosu::KbEscape))
		Menu1.new.show
		#digunakan jika pengguna menekan tombol escape pada saat game over, maka akan memanggil class Menu1 untuk dieksekusi
		end
	end
	if (button_down?(Gosu::KbEscape))
		Menu1.new.show
	end
	@song.play(true)
  end
  
  def draw
    @blocks.each { |block| block.draw }
	@falling_shape.draw
	@text3.draw("#{@score}",400,20,2)
	@text4.draw(320,20,2)
	@text5.draw(320,75,2)
	@text6.draw("#{@lines_cleared}",400,75,2)
	@gambar.draw(305,10,1)
	@gambar2.draw(305,65,1)
	#digunakan untuk mencetak nilai score dan line yang telah diselesaikan
	
	color = case @hit
			when 0
				Gosu::Color::NONE
			when 1
				Gosu::Color::WHITE
			when -1
				Gosu::Color::BLACK
			end
	@hit = 0
	draw_quad(0,0,color,1000,0,color,800,700,color,0,1000,color)
	
	
	if @state == STATE_GAMEOVER
	   text = Gosu::Image.from_text(self, "Game Over", "Arial", 40)
	   text.draw(146,380,3)
	   text1 = Gosu::Image.from_text(self, "Space to Start Play Again", "Arial", 30)
	   text1.draw(90,415,3)
	   text2 = Gosu::Image.from_text(self, "Escape to Back to Main Menu", "Arial", 30)
	   text2.draw(65,440,3)
	   gambar3 = Gosu::Image.new(self, "media/lotak.png")
	   gambar3.draw(34,350,2)
	   @text4.draw(75,525,3)
	   @text3.draw("#{@score}",155,525,3)
	   @text5.draw(265,525,3)
	   @text6.draw("#{@lines_cleared}",345,525,3)
	   @gambar.draw(60,515,2)
	   @gambar2.draw(250,515,2)
	   #fungsi if diatas akan berjalan jika game telah selesai atauu game over, maka akan menampilkan tulisan sesuai dengan yang ada diatas
	end
  end
  
  def button_down(id)
    if ( id == Gosu::KbSpace && @falling_shape != nil )
      @falling_shape.rotation += 1
	  if ( @falling_shape.collide )
	    @falling_shape.rotation -= 1
	  end
	end
  end
  #digunakan jika pengguna menekan spasi pada keyboard maka objek akan memutar 90 derajat searah jarum jam
  
  def spawn_next_shape
    if (@falling_shape != nil )
	  @blocks += @falling_shape.get_blocks 
	end
	 
	generator = Random.new
	shapes = [ShapeI.new(self), ShapeL.new(self), ShapeJ.new(self), ShapeCube.new(self), ShapeZ.new(self), ShapeT.new(self), ShapeS.new(self)]
	shape = generator.rand(0..(shapes.length-1))
    @falling_shape = shapes[shape]
  end
  #method diatas merupakan method yang digunakan untuk merespown blaok yang sudah dibuat secara acak atau random
  
  def line_complete(y)
	i = @blocks.count{|item| item.y == y}
	if ( i == width / block_width )
		@hit = 1
		@score += HIT_SCORE
		if (@score > 200)
			@score += 100
		end
		if (@score > 500)
			@score += 100
		end
		if (@score > 800)
			@score += 100
		end
		return true;
	end
	return false;
  end
  #digunakan untuk mencek apakah line sudah penuh satu garis dan sekaligus memberikan nilai jika line telah penuh satu garis
  
  def delete_lines_of( shape )
    deleted_lines = []
    shape.get_blocks.each do |block|
		if ( line_complete(block.y) )
		   deleted_lines.push(block.y)
		   @blocks = @blocks.delete_if { |item| item.y == block.y }
		end
	end

	@lines_cleared += deleted_lines.length 
	@blocks.each do |block|
	  i = deleted_lines.count{ |y| y > block.y }
	  block.y += i*block_height
	end
	
  end
  
end
