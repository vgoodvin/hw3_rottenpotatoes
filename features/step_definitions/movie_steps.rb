# Add a declarative step here for populating the DB with movies.

require 'nokogiri'

Given /the following movies exist/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
    Movie.create!(
        :title => movie['title'],
        :rating => movie['rating'],
        :release_date => movie['release_date']
    )
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  doc = Nokogiri::HTML(page.body)
  regexp = Regexp.new "#{e1}.*#{e2}"
  assert ! doc.text.gsub(/\n|\t/s, '').match(regexp).nil?
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(',').each { |rating| rating.strip! }
  ratings.each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

Then /I should see all of the movies/ do
  assert page.has_css?("table#movies tbody tr", :count => Movie.count)
end

Then /I should not see any movie/ do
  assert ! page.has_css?("table#movies tbody tr")
end

Then /movies should be in increasing order of "(.*)"/ do |field|
  movies = Movie.all(:order => field)
  movies.each_index do |i|
    step %Q{I should see "#{movies[i][field]}" before "#{movies[i+1][field]}"} unless movies[i+1].nil?
  end
end
