# Add a declarative step here for populating the DB with movies.

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

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
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

Given /I have added "(.*)" with rating "(.*)"/ do |title, rating|
  Given %Q{I am on the Create New Movie page}
  When  %Q{I fill in "Title" with "#{title}"}
  And   %Q{I select "#{rating}" from "Rating"}
  And   %Q{I press "Save Changes"}
end

Then /I should see "(.*)" before "(.*)" on (.*)/ do |string1, string2, path|
  Given %Q{I am on #{path}}
  regexp = Regexp.new ".*#{string1}.*#{string2}"
  page.body.should =~ regexp
end
