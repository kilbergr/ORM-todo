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
			@title = args[:item]
		end
	end

	def self.all
		c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
		results = []
		res = c.exec "SELECT * FROM todos";
		res.each do |todos|
			id = todo|'id'|
			item = todo|'item'|
			results << Todo.new({:id => id, :item => item})
		end
		results
	end

	def delete
		sql = "DELETE FROM todos WHERE id=$1"
		args = [id]
		@c.exec_params(sql, args)
	end

	def update
		sql = "UPDATE todos SET item=$1 WHERE id=$2;"
		args = [item, id]
		@c.exec_params(sql, args)
	end

	def close
		@c.close
	end

	private
	def connect
		@c = PGconn.new(:host => HOSTNAME, :dbname => DATABASE)
	end
end


puts "Welcome to the todo app, what would you like to do? Enter specified key for following result.
o - see options
n - make a new todo
l - list all todos
u [id] - update a todo with a given id
d [id] - delete a todo with a given id, if no id is provided, all todos will be deleted
q - quit the application"

input = gets.chomp
while input == !q
	if input == o
		puts %q{Welcome to the todo app, what would you like to do? Enter specified key for following result.
		o - see options
		n - make a new todo
		l - list all todos
		u [id] - update a todo with a given id
		d [id] - delete a todo with a given id, if no id is provided, all todos will be deleted
		q - quit the application}
		input = gets.chomp
	end

	if input == n
		puts "Please enter the todo:"
		new_todo = gets.chomp
		todo = Todo.new({:id => id, :item => new_todo})
		todo.save
		puts "You've successfully added a todo! Enter 'o' to return to options."
		input = gets.chomp
	end

	if input == l
		puts Todo.all
		puts "What next? Enter 'o' to return to options."
		input = gets.chomp
	end

	if input == u[id]
		
	end
end

