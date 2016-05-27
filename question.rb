require 'rexml/document'

class Question

  # Создает экземпляры собственного класса и возвращает их в массиве 
  def self.questions_factory(xml_file_name)
    
    begin
      file = File.new(xml_file_name, 'r:utf-8')
      doc = REXML::Document.new(file)
      file.close
    rescue Errno::ENOENT
      abort "Не удалось открыть файл #{xml_file_name}"
    end

    questions = []

    doc.elements.each('questions/question') do |questions_element|       
      
      question_data = {time: "#{questions_element.attributes['seconds'].to_f}"}

      variants = []      

      questions_element.elements.each do |question_element|    
        case question_element.name
        when 'text' then question_data[:text] = question_element.text
        when 'variants'
          question_element.elements.each_with_index do |variant, index|
            variants << variant.text      
            question_data[:right_answer_index] = index + 1 if variant.attributes['right']   
          end          
          question_data[:variants] = variants
        end
      end

      questions << self.new(question_data)    

    end
    return questions
  end


  def initialize(question_data)   
    @question_data = question_data
  end


  def ask_question
    @time_for_question = @question_data[:time].to_f    

    puts "\nВремя на ответ: #{@time_for_question} сек."
    puts '3'
    sleep(1)
    puts '2'
    sleep(1)
    puts '1'
    sleep(1)

    @start_time = Time.now

    puts @question_data[:text]

    @question_data[:variants].each_with_index do |variant, index|
      puts "#{index+1}. #{variant}"
    end    

    take_user_input

    @end_time = Time.now    
  end


  def take_user_input
    @user_input = STDIN.gets.chomp
  end


  def check_answer
    if @user_input == @question_data[:right_answer_index].to_s
      if @time_for_question >= @end_time - @start_time
        puts 'Верно!'
        return 1
      else
        puts 'Вы не уложились в отведенное для ответа время.'
        return 0
      end
    else
      puts 'Неправильный ответ!'
      return 0
    end
  end

end