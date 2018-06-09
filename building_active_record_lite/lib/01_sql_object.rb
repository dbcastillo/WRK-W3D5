require_relative 'db_connection'
require 'active_support/inflector'
require "byebug"
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns.first.map!(&:to_sym) if @columns
      @columns = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM cats
      SQL
    @columns.first.map!(&:to_sym)
  end

  def self.finalize!
     # byebug
    columns.each do |name|
      # byebug
      define_method(name) do
         # byebug
         self.attributes[name]
      end
      define_method("#{name}=") do |argument|
# byebug
        self.attributes[name] = argument
      end
 # byebug
    end
  end

  def self.table_name=(table_name)
    # return "humans" if table_name == "Human"
    # self.class.tableize
     @table_name = table_name.tableize

    end

  def self.table_name
    return "humans" if self.to_s == "Human"

    self.to_s.tableize
    # define_method(:table_name) do
    #   instance_variable_get("@#{table_name}")
    # end
  end

  def self.all
    # self.find_by_sql("SELECT * FROM cats")
    x = DBConnection.execute(<<-SQL)
    SELECT *
    FROM cats
    SQL
    # byebug
  end

  def self.parse_all(results)
    result = []
    results.each do |hash|
        hash.each do |k, v|
          result << self.new.send("#{k}=", v) #!!!!!
        end
    end
    result
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |k,v|
      unless self.class.columns.include?(k.to_sym)
        debugger
        raise "unknown attribute '#{k}'"
      else
        self.send("#{k}=", v)
      end
    end

  end

  def attributes
    @attributes ||= {}

  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
