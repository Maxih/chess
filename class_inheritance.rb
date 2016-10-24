class Employee

  def initialize(name,title,salary,boss)
    @name, @title, @salary = name, title, salary
    self.boss = boss
  end

  def bonus(multiplier)
    self.salary * multiplier
  end

  def boss=(manager)
    unless manager.nil?
      @boss = manager
      manager.employees << self
    end
  end

  protected
  attr_reader :salary

end

class Manager < Employee

  attr_accessor :employees

  def initialize(name,title,salary,boss)
    super
    @employees = []
  end

  def bonus(multiplier)
    sum = 0
    subordinates = self.employees
    until subordinates.empty?
      sub = subordinates.shift
      subordinates += sub.employees if sub.is_a?(Manager)
      sum += sub.salary
    end

    sum*multiplier
  end

end

if __FILE__ == $PROGRAM_NAME
  ned = Manager.new("Ned","Founder",1000000,nil)
  darren = Manager.new("Darren","TA Manager",78000,ned)
  shawna = Employee.new("Shawna","TA",12000,darren)
  david = Employee.new("David","TA",10000,darren)

  p ned.bonus(5)
  p darren.bonus(4)
  p david.bonus(3)
end
