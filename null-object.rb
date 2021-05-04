# Class that we will check uppon the dependent property later on
class Site
  attr_reader :customer

  def initialize(cust)
    @customer = cust
  end

  def customer
    # Trick to return default customer in case it is null
    @customer || Customer.new_missing
  end
end

# Null object that will always return default anwers
class MissingCustomer
  attr_accessor :name, :plan, :history

  def missing?; true; end

  # always return default answer in case of a null customer
  def name
    'occupant'
  end

  # always return default answer in case of a null customer
  def plan
    0
  end
end

# non-nullable customer.
class Customer
  attr_reader :name, :history
  attr_accessor :plan

  def initialize(name, plan, history)
    @name = name
    @plan = plan
    @history = history
  end

  # Pattern to inform the dependent class that this instance is not null. Could be inside a mixin module
  def missing?; false; end

  # static factory-method to return a null-object.
  def self.new_missing
    MissingCustomer.new
  end
end

# old way of null checking
puts "\nUsing null object checking"
site = Site.new(nil)
customer = site.customer
puts "    Customer plan: #{customer.nil? ? '0' : customer.plan}"
puts "    Customer name: #{customer.nil? ? 'occupant' : customer.name}"
customer.plan = 1 unless customer.nil?
puts "    Customer plan after changing it: #{customer.nil? ? '0' : customer.plan}"

# using null objects. There is no checks if the object is null or not
puts "\nUsing null object pattern"
site = Site.new(nil)
customer = site.customer
puts "    Customer plan: #{customer.plan}"
puts "    Customer name: #{customer.name}"
customer.plan = 1
puts "    Customer plan after changing it: #{customer.plan}"

puts "\nUsing a not-null customer"
site = Site.new(Customer.new('name', 123, 'hist'))
customer = site.customer
puts "    Customer plan: #{customer.plan}"
puts "    Customer name: #{customer.name}"
customer.plan = 1
puts "    Customer plan after changing it: #{customer.plan}"
