require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
       scraped_students = []
       doc.css("div.student-card").each do |student|
       name = student.css(".student-name").text
       location = student.css(".student-location").text
       profile_url = student.css("a").attr("href").text
       student_hash = {
          :name => name,
          :location => location,
          :profile_url => profile_url
          }
         scraped_students << student_hash
      end
      scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    student_hash = {}

     container = doc.css("div.social-icon-container a").collect do |icon|
       icon.attribute("href").value
     end

     container.each do |link|
      if link.include?("twitter")
        student_hash[:twitter] = link
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
      elsif link.include?("github")
        student_hash[:github] = link
      elsif link.include?(".com")
        student_hash[:blog] = link
     end
   end

   student_hash[:profile_quote] = doc.css("div.profile-quote").text
   student_hash[:bio]=  doc.css("div.description-holder p").text

  student_hash
  #  university = doc.css("div.education-block h4").text
  #  major = doc.css("div.education-block h5").text
  #  previous_position = doc.css("div.experience-block h4").text
  #  position_description = doc.css("div.experience-block h5").text

end

end
