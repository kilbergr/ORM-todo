require "pry"
require "pg"

HOSTNAME = :localhost
DATABASE = :testdb

class Todo	
	attr_accessor :id, :item 

	def self.make_todo_table
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		c.exec %q{
			CREATE TABLE todos (
				id SERIAL PRIMARY KEY,
				item TEXT
			);
		}
		c.close
	end

	def self.create(args)
		todo = Todo.new(args)
		todo.save
	end

	def save
		sql = "INSERT INTO todos (item"
		args = [item]

		if id.nil?
			sql += ") VALUES ($1)"
		else
			sql += ", id VALUES ($1, $2)"
			args.push id
		end
		
		sql += ' RETURNING *;'

		res = @c.exec_params(sql, args)
		@id = res[0]['id']
		self
	end

	def initialize(args)
		connect
		if args.has_key? :id
			@id = args[:id]
		end

		if args.has_key? :item
			@item = args[:item]
		end
	end

	def self.all
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		results = []
		res = c.exec "SELECT * FROM todos";
		res.each do |todo|
			id = todo['id']
			item = todo['item']
			results << Todo.new({:id => id, :item => item})
		end
		results
	end

	def find(args)
		sql = "SELECT item FROM todos WHERE id = $1;"
		@c.exec_params(sql,args)
	end

	def delete_one
		sql = "DELETE FROM todos WHERE id=$1"
		args = [id]
		@c.exec_params(sql, args)
		self
	end

	def self.delete_all
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		c.exec "DELETE FROM todos"
	end

	def update
		sql = "UPDATE todos SET item=$1 WHERE id=$2;"
		args = [item, id]
		@c.exec_params(sql, args)
		self
	end

	def to_s
		"ID: #{@id}. #{@item}"
	end

	def close
		@c.close
	end

	private
	def connect
		@c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
	end
end

#Made already Todo.make_todo_table

puts "Welcome to the todo app, what would you like to do? Enter specified key for following result.
o - see options
n - make a new todo
l - list all todos
u - update a todo with a given id
d - delete a todo with a given id, if no id is provided, all todos will be deleted
q - quit the application"

input = gets.chomp
until input == "q"
	if input == "o"
		puts %q{Welcome to the todo app, what would you like to do? Enter specified key for following result.
		o - see options
		n - make a new todo
		l - list all todos
		u - update a todo with a given id
		d - delete a todo with a given id, if no id is provided, all todos will be deleted
		q - quit the application}
		input = gets.chomp
	end

	if input == "n"
		puts "Please enter the todo:"
		new_todo = gets.chomp
		todo = Todo.new({:item => new_todo})
		todo.save
		todo.close
		puts "You've successfully added a todo! Enter 'o' to return to options."
		input = gets.chomp
	end

	if input == "l"
		puts Todo.all
		puts "What next? Enter 'o' to return to options."
		input = gets.chomp
	end

	if input == "u"
		puts "Please enter the id of the todo you'd like to update:"
		todo_id = gets.chomp.to_i
		# todo.find(todo_id)
		puts "Please enter your updated todo:"
		updated_todo = gets.chomp
		u = Todo.new({:id => todo_id, :item => updated_todo})
		u.update
		puts "You've successfully updated a todo! Enter 'o' to return to options."
		input = gets.chomp
	end

	if input == "d"
		puts "Please enter the id of the todo you'd like to delete:"
		todo_id = gets.chomp.to_i
		if todo_id == nil
			Todo.delete_all
			puts "You've successfully deleted all todos! Enter 'o' to return to options."
		else 
			# todo.find(todo_id)
			todo.delete_one
			puts "You've successfully deleted a todo! Enter 'o' to return to options."
		end
		input = gets.chomp
	end

end

