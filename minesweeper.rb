module Board
  extend self

  def transform(board)
    @board = board

    validate
    fill_board!

    @board
  end

  private

  def validate
    @first_row_length = @board.first.length
    @last_column = @board.length

    @board.each_with_index do |row, row_index|
      validate_row_length(row)

      row.split('').each_with_index do |cell, col_index|
        validate_cell(row_index, col_index, cell)
      end
    end
  end

  # validations
  
  def validate_row_length(row)
    return if row.length == @first_row_length

    raise ArgumentError
  end

  def validate_cell(row_index, col_index, cell)
    if is_corner?(row_index, col_index)
      validate_corner(cell)
    elsif is_horizontal_edge?(row_index, col_index)
      validate_horizontal_edge(cell)
    elsif is_vertical_edge?(row_index, col_index)
      validate_vertical_edge(cell)
    else
      validate_board_cell(cell)
    end
  end

  def is_corner?(row_index, col_index)
    is_horizontal_edge?(row_index, col_index) && is_vertical_edge?(row_index, col_index)
  end

  def is_horizontal_edge?(row_index, col_index)
    (row_index == 0 || row_index == @last_column - 1)
  end

  def is_vertical_edge?(row_index, col_index)
    (col_index == 0 || col_index == @first_row_length - 1)
  end

  def is_board_cell?(row_index, col_index)
    !is_horizontal_edge?(row_index, col_index) && !is_vertical_edge?(row_index, col_index)
  end

  def validate_corner(cell)
    raise ArgumentError unless cell == "+"
  end

  def validate_horizontal_edge(cell)
    raise ArgumentError unless cell == "-"
  end

  def validate_vertical_edge(cell)
    raise ArgumentError unless cell == "|"
  end

  def validate_board_cell(cell)
    raise ArgumentError unless cell == " " || cell == "*"
  end
  
  # populating the board

  def fill_board!
    @board[1...(@board.length - 1)].each_with_index do |row, row_index|
      row[1...(row.length - 1)].split('').each_with_index do |cell, col_index|
        fill_cell(cell, row_index, col_index)
      end
    end
  end

  def fill_cell(cell, row_index, col_index)
    return if cell == "*"

    adject_bombs = count_adjacent_bombs(row_index + 1, col_index + 1)
    @board[row_index + 1][col_index + 1] = adject_bombs.to_s if adject_bombs > 0
  end

  def count_adjacent_bombs(row, col)
    [
      check_bomb(row - 1, col - 1), # up left
      check_bomb(row - 1, col    ), # up
      check_bomb(row - 1, col + 1), # up right
      check_bomb(row    , col - 1), # left
      check_bomb(row    , col + 1), # right
      check_bomb(row + 1, col - 1), # down left
      check_bomb(row + 1, col    ), # down
      check_bomb(row + 1, col + 1), # down right
    ].sum
  end

  def check_bomb(row, col)
    @board[row][col] == "*" ? 1 : 0
  end
end