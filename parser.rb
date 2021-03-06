require 'nokogiri'
require 'open-uri'

class Rb7parser

	attr_reader :top_movies

	URL = 'https://rb7.ru/afisha/movies'.freeze


	def initialize
		@movies = []
		top if load_html
	end

	def load_html
		html = URI.open(URL)
		doc = Nokogiri::HTML(html)
		parse(doc)
	end

	def parse(html)
		html.css('.movie').map do |m|
			seanses = 0
			title = m.at_css('h2 a').inner_html.strip
			table = m.css('.afisha-schedule')
			kinoteaters = table.search('tr').each do |tr|
				seanses += tr.css("td").css('.when').css('.show').count
			end
			@movies << { title: title, seanses: seanses }
		end
	end

	def top
		@top_movies = @movies.sort_by{|key| key[:seanses]}.last(3).reverse!
	end
end

p = Rb7parser.new
p.top_movies.each do |t|
	puts "#{t[:title]} : #{t[:seanses]}"
end