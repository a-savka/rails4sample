module ApplicationHelper

	def build_title(page_name)
		result_title = "Ruby on Rails tutorial sample app"
		result_title << " | #{page_name}" if !page_name.empty?
		result_title
	end

end
