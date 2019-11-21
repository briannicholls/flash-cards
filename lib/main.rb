require 'json'
require 'pry'


class Quiz
  def initialize
    @quiz
    @title
    @questions = [] # AoH
    @filepath = ""

    menu_loop
  end

  def set_path(input = gets.strip)
    @filepath = "./bin/quizzes/#{input}.txt"
  end

  def load_quiz

  end

  def add_question
    puts "What is the question?"
    q = gets.strip
    puts ""
    puts "What is the answer?"
    a = gets.strip
    @questions.push({'question' => q, 'answer' => a})
    puts ""
    puts ""
  end

  def edit_loop
    puts ""
    puts "Begin adding questions. Type 'exit' to return to main menu."
    puts ""
    loop do
      add_question
      write_all_questions_to_file
    end

  end

  def get_questions_from_file
    @questions.clear
    file = File.open(@filepath)
    data = file.readlines.map do |line|
      @questions.push(JSON.parse(line.gsub('=>',':')))
    end
    file.close
  end

  def write_all_questions_to_file
    File.open(@filepath, 'w') { |f|
      @questions.each{ |question|
        f.write(question)
        f.write("\n")
      }
    }
  end

  def start_quiz
    test_loop
  end

  def test_loop
    q_index = 0.0
    correct = 0.0
    @questions = @questions.sample(@questions.length)
    while q_index < @questions.length
      cur_ques = @questions[q_index]
      puts "#{cur_ques['question']}"
      answer = gets.strip
      if answer != cur_ques['answer']
        puts "WRONG! Correct answer: #{cur_ques['answer']}"
      else
        puts "Correct!"
        correct += 1
      end
      q_index += 1
      puts ""
    end
    puts "End of Quiz!"
    percent = (correct / q_index) * 100.0
    puts "You scored #{percent}%"
    puts ""
  end

  def create_new_quiz
    set_path
    if File.exists?(@filepath)
      puts "Specified quiz already exists!"
    else
      File.new(@filepath, 'w')
      puts "Quiz created at #{@filepath}!"
    end
    puts " "
  end

  def menu_loop
    loop do
    puts "What would you like to do?"
    puts "1. Create New Quiz"
    puts "2. Edit Existing Quiz"
    puts "3. Start Quiz!"
    puts "4. Exit"
    input = gets.strip

    case input
    when "1"
      create_new_quiz
    when "2"
      display_quizzes
      edit_loop
    when "3"
      display_quizzes
      start_quiz
    when "4"
      exit
    end
  end

  end

  def display_quizzes
    puts ""
    puts "*** Select a quiz! ***"
    path = "./bin/quizzes"
    quiz_names = Dir.entries(path)
    quiz_names = quiz_names[2..(quiz_names.length - 1)].map{|name| name.gsub(".txt","")}
    quiz_names.each_with_index{|name,index| puts "#{index + 1} : #{name}" }
    puts ""
    puts "Enter number 1 - #{quiz_names.length}"
    input_to_index = gets.strip.to_i - 1
    file_name = quiz_names[input_to_index]
    set_path(file_name)
    get_questions_from_file
  end

end
