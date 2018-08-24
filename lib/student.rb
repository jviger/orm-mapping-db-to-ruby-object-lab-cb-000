class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
      new_student = self.new
      new_student.id = row[0]
      new_student.name =  row[1]
      new_student.grade = row[2]
      new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    grade_9_students = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL
 
    DB[:conn].execute(sql, 9).map do |row|
      grade_9_students << self.new_from_db(row)
    end
    grade_9_students
  end
  def self.first_X_students_in_grade_10(num_students)
    grade_10_students = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
    SQL
 
    DB[:conn].execute(sql, 10,num_students).map do |row|
      grade_10_students << self.new_from_db(row)
    end
    grade_10_students
  end
  def self.first_student_in_grade_10
    grade_10_student = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql).map do |row|
      grade_10_student << self.new_from_db(row)
    end.first
    grade_10_student
  end
  
  def self.students_below_12th_grade
    below_12_students = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
      
    SQL
 
    DB[:conn].execute(sql).map do |row|
      below_12_students << self.new_from_db(row)
    end
    below_12_students
  end
end
