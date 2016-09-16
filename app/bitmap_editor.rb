require 'byebug'
class BitmapEditor

  REGX_IMAGE      = /^[I]\s\d{1,}\s\d{1,}$/
  REGX_COLOR      = /^[L]\s\d{1,}\s\d{1,}\s[A-Z]$/
  REGX_VERTICAL   = /^[V]\s\d{1,}\s\d{1,}\s\d{1,}\s[A-Z]$/
  REGX_HORIZONTAL = /^[H]\s\d{1,}\s\d{1,}\s\d{1,}\s[A-Z]$/

  def run
    @running = true

    puts 'type ? for help'
    while @running
      print '> '
      @input = gets.chomp
      case @input
        when REGX_IMAGE
          create_bitmap_image

        when REGX_COLOR
          color_bitmap_image

        when REGX_VERTICAL
          color_bitmap_image_vertically

        when REGX_HORIZONTAL
          color_bitmap_image_horizontally

        when '?'
          show_help

        when 'X'
          exit_console

        when 'S'
          show_bitmap_image

        else
          puts 'unrecognised command :(. The syntax is:'
          show_help
      end
    end
  end

  private

    def create_bitmap_image
      # I 5 6
      # OOOOO
      # OOOOO
      # OOOOO
      # OOOOO
      # OOOOO
      # OOOOO

      #  Set default pixel and clear any previous buffer
      pixel = "O"
      @bitmap_array = []

      # Create bitmap image
      raw_image = @input.split
      image_col = raw_image[1].to_i
      image_row = raw_image[2].to_i
      p "col: #{image_col}  row: #{image_row}"

      # Associate corresponding col and row pixel to array
      while image_col > 0
        while image_row > 0
          print "O" * image_col
          @bitmap_array[image_row - 1] = "O" * image_col
          print "\n"
          image_row = image_row - 1
        end
        image_col = image_col - 1
      end

      # Yet another way to create bitmap image
      # bitmap_array = Array.new(image_col) { Array.new(image_row, pixel) }
      # print bitmap_array
    end

    def color_bitmap_image
      # L 2 3 A
      # OOOOO
      # OOOOO
      # OAOOO
      # OOOOO
      # OOOOO
      # OOOOO

      i = 0
      raw_color = @input.split
      color_col = raw_color[1].to_i
      color_row = raw_color[2].to_i
      color     = raw_color[3]

      p "color_col: #{color_col}  color_row: #{color_row}"
      # Paint in the bitmap image with color for corresponding col and row
      @bitmap_array[color_row - 1][color_col - 1] = color
      while i < @bitmap_array.length
        print @bitmap_array[i]
        print "\n"
        i = i + 1
      end
    end

    def color_bitmap_image_vertically
      # V 2 3 6 W
      # OOOOO
      # OOOOO
      # OWOOO
      # OWOOO
      # OWOOO
      # OWOOO

      j = 0
      k = 0
      raw_vertical = @input.split
      vertical_col = raw_vertical[1].to_i
      row_start_range = raw_vertical[2].to_i
      row_end_range    = raw_vertical[3].to_i
      color_vertical = raw_vertical[4]

      bitmap_array_vertical = @bitmap_array[(row_start_range - 1)..row_end_range]

      p "vertical_col: #{vertical_col}  row_start_range: #{row_start_range}  row_end_range: #{row_end_range}"
      begin
        while j < bitmap_array_vertical.length
          bitmap_array_vertical[j][vertical_col - 1] = color_vertical
          j = j + 1
        end

        while k < @bitmap_array.length
          print @bitmap_array[k]
          print "\n"
          k = k + 1
        end
      rescue StandardError => e
        puts e
      end
    end

    def create_bitmap_image_horizontally
      # H 3 5 2 Z
      # OOOOO
      # OOZZZ
      # OWOOO
      # OWOOO
      # OWOOO
      # OWOOO
      #
      l = 0
      m = 0
      raw_horizontal = @input.split
      col_start_range = raw_horizontal[1].to_i
      # col_end_range = raw_horizontal[2].to_i
      col_end_range = (raw_horizontal[2].to_i < image_col) ? raw_horizontal[2].to_i : raw_image[1].to_i

      horizontal_row = raw_horizontal[3].to_i
      color_horizontal = raw_horizontal[4]
      bitmap_string_horizontal = @bitmap_array[horizontal_row - 1]
      # bitmap_string_replace = bitmap_string_horizontal[col_start_range, col_end_range]
      p "bitmap_string_horizontal: #{bitmap_string_horizontal}"
      p "horizontal_row: #{horizontal_row}  col_start_range: #{col_start_range}  col_end_range: #{col_end_range}"
      bitmap_string_horizontal[col_start_range -1 , col_end_range] = color_horizontal * ((col_end_range - col_start_range) + 1 )
      p "bitmap_string_horizontal_after_manipulation: #{bitmap_string_horizontal}"

      begin
        while l < @bitmap_array.length
          print @bitmap_array[l]
          print "\n"
          l = l + 1
        end
      rescue StandardError => e
        puts e
        end
    end


    def exit_console
      puts 'goodbye!'
      @running = false
    end

    def show_bitmap_image
      o = 0
      begin
        while o < @bitmap_array.length
          print @bitmap_array[o]
          print "\n"
          o = o + 1
        end
      rescue StandardError => e
        puts e
      end
    end

    def show_help
      puts "
            ? - Help
            I M N - Create a new M x N image with all pixels coloured white (O).
            C - Clears the table, setting all pixels to white (O).
            L X Y C - Colours the pixel (X,Y) with colour C.
            V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
            H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
            S - Show the contents of the current image
            X - Terminate the session
          "
    end
end
