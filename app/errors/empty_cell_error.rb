class EmptyCellError < StandardError
  def initialize(col, row)
    @col = col    
    @row = row
  end

  def message
    "El archivo seleccionado presenta un error en la celda #{@col}#{@row}. Por favor, corríjalo y vuelva a intentarlo."
  end
end