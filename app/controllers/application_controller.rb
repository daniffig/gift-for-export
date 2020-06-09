class ApplicationController < ActionController::Base
  add_flash_types :info, :danger, :warning

  rescue_from ActionController::ParameterMissing, with: :file_missing
  rescue_from QuestionsMissingError, with: :questions_missing
  rescue_from WrongFileError, with: :wrong_file

  rescue_from EmptyCellError do |e|
    redirect_to new_url, danger: e.message
  end

  def file_missing
    redirect_to new_url, warning: 'Debe seleccionar un archivo.'
  end

  def questions_missing
    redirect_to new_url, danger: 'El archivo seleccionado no contiene preguntas.'
  end

  def wrong_file
    redirect_to new_url, danger: 'El archivo seleccionado es incorrecto.'
  end

  def new
  end

  def convert
    params.require(:test).permit(:file)

    test = params[:test]

    raise WrongFileError unless File.extname(test[:file]) == '.xlsx'

    xlsx = Roo::Spreadsheet.open(test[:file])

    c_template = "$CATEGORY: %{c}\r\n\r\n"
    q_template = "// name: %{q}\r\n%{q} {\r\n\t=%{a_a} # %{f_a}\r\n\t~%{a_b} # %{f_b}\r\n\t~%{a_c} # %{f_c}\r\n\t~%{a_d} # %{f_d}\r\n}\r\n\r\n"

    rows = []

    xlsx.sheet(0).parse(headers: true).each { |row| rows << row }

    rows.shift

    raise QuestionsMissingError unless rows.size > 0

    gift = ''
    gift += "// created with GiftForExport - https://gift.noack.net.ar\r\n"
    gift += "// developed by daniffig <daniffig@gmail.com> - https://github.com/daniffig\r\n\r\n"

    @row_number = 2

    rows.each do |row|
      gift += c_template % { c: row['CATEGORIA'] }

      gift += q_template % {
        q: escape_string(row, 'PREGUNTA'),
        a_a: escape_string(row, 'RESPUESTA_A'),
        f_a: escape_string(row, 'FEEDBACK_A'),
        a_b: escape_string(row, 'RESPUESTA_B'),
        f_b: escape_string(row, 'FEEDBACK_B'),
        a_c: escape_string(row, 'RESPUESTA_C'),
        f_c: escape_string(row, 'FEEDBACK_C'),
        a_d: escape_string(row, 'RESPUESTA_D'),
        f_d: escape_string(row, 'FEEDBACK_D')
      }

      @row_number += 1
    end

    send_data(gift, filename: 'test.gift', type: 'text/plain', disposition: :attachment)
  end

  def download_template
    send_file(Rails.root.join('private', 'files', 'template.xlsx'), filename: 'GiftForExport - Plantilla.xlsx', disposition: :inline)
  end

  def download_example
    send_file(Rails.root.join('private', 'files', 'example.xlsx'), filename: 'GiftForExport - Ejemplo.xlsx', disposition: :inline)
  end

  private

  def escape_string(row, key)    
    string = row[key]

    begin
      string = string.to_s
      string.gsub!("\n", '')
      string.gsub!("\r", '')
      string.gsub!('~', '\~')
      string.gsub!('=', '\=')
      string.gsub!('#', '\#')
      string.gsub!('{', '\{')
      string.gsub!('}', '\}')

      string
    rescue
      raise EmptyCellError.new(key_to_column(key), @row_number)
    end
  end

  def key_to_column(string)
    columns = {
      'CATEGORIA' => 'A',
      'PREGUNTA' => 'B',
      'RESPUESTA_A' => 'C',
      'FEEDBACK_A' => 'D',
      'RESPUESTA_B' => 'E',
      'FEEDBACK_B' => 'F',
      'RESPUESTA_C' => 'G',
      'FEEDBACK_C' => 'H',
      'RESPUESTA_D' => 'I',
      'FEEDBACK_D' => 'J',
    }

    columns[string]
  end
end


# // opción múltiple con retroalimentación especificada para respuestas correctas e incorrectas
# ::Q2:: ¿Qué color hay entre el naranja y el verde en el espectro? 
# { =Amarillo# correcto; bien! ~rojo # incorrecto, es amarillo ~azul # incorrecto, es amarillo }
