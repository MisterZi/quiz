
require_relative 'question.rb'


current_path = File.dirname(__FILE__)
file_name = current_path + '/questions.xml'

questions = Question.questions_factory(file_name)

puts "\nВикторина v2.2\n"
sleep(1)

right_answers_counter = 0

questions.each do |question|
  question.ask_question
  right_answers_counter += question.check_answer
end

puts "\nУ Вас #{right_answers_counter} правильных ответов"