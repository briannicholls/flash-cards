require 'json'
require 'pry'


class Quiz
  def initialize
    @quiz
    @title
    @questions = [] # AoH
    @filepath = "./bin/quizzes/sample_file.txt"

    #get_questions_from_file
    #write_all_questions_to_file
    #puts @questions
    menu_loop
  end

  def set_path
    puts "Enter quiz name:"
    input = gets.strip
    @filepath = "./bin/quizzes/#{input}.txt"
  end

  def add_question
    puts "What is the question?"
    q = gets.strip
    puts "What is the answer?"
    a = gets.strip
    @questions.push({'question' => q, 'answer' => a})
  end

  def edit_loop
    set_path
    get_questions_from_file

    loop do
      add_question
      write_all_questions_to_file
    end
    
  end

  def get_questions_from_file
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
    set_path
    get_questions_from_file
    test_loop
  end

  def test_loop
    q_index = 0
    while q_index < @questions.length
      cur_ques = @questions[q_index]
      puts "#{cur_ques['question']}"
      answer = gets.strip
      if answer != cur_ques['answer']
        puts "WRONG! Correct answer: #{cur_ques['answer']}"
      else
        puts "Correct!"
      end
      q_index += 1
    end

  end

  def create_new_quiz
    set_path
    if File.exists?(@filepath)
      puts "Specified quiz already exists!"
    else
      File.new(@filepath, 'w')
      puts "Quiz created at #{@filepath}!"
      puts " "
    end
  end



  def menu_loop
    loop do
    puts "What would you like to do?"
    puts "1. Create New Quiz"
    puts "2. Edit Existing Quiz"
    puts "3. Start Quiz!"
    input = gets.strip

    case input
    when "1"
      create_new_quiz
    when "2"

      edit_loop
    when "3"
      start_quiz
    end
  end

  end
end
