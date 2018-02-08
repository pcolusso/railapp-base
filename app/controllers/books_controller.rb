class BooksController < ApplicationController
	def new

	end

	def create
		@book = Book.new(params[:book])
		@book.save

		redirect_to @book
	end

	def show
		@book = Book.find(params[:id])
	end

	def index
		@books = Book.all
	end
end
