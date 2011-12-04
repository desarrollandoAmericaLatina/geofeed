module ApplicationHelper

  def short_url long_url
   @bitly ||= Bitly.new('mediadecision','R_f5fb9f543e1257eb09d83d546e141f2b')
   if Rails.env.development?
     long_url = 'http://www.google.cl'
   end
   page_url = @bitly.shorten(long_url)
   page_url.shorten
  end
 
end
