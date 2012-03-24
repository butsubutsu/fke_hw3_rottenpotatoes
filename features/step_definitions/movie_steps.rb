# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
  # each returned element will be a hash whose key is the table header.
  # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#  ensure that that e1 occurs before e2.
#  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
def checkboxName(prefix,suffix)
  (prefix+""+suffix).tr('"', "")
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
# HINT: use String#split to split up the rating_list, then
#   iterate over the ratings and reuse the "When I check..." or
#   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  lst=rating_list.split(',')
  lst.each do |r|
    cbn=checkboxName("ratings_",r)
    if (uncheck==true)then
      #lst.each{|r|  step "When I uncheck "+r+(checkboxName("ratings_",r))}
      uncheck(cbn)
    else
      check(cbn)
    end
  end
end
#(^"[^"]*"(,\s*"[^"]*")*)
Then /I should see (no)?\s?movies with the following ratings: (.*)/ do|no,rating_list|
  lst=rating_list.split(',')
  inValueList=lst.map{|r| r.to_s.tr('"','')}
  if no==true then
  inValueList.each do |k|
    p '*'
    p page.find("#movies tbody td").inspect
  assert  page.has_no_css?("#movies tbody td",:text=>k)  
  end
  else
     #assert page.find('table#movies').find('#movies ')#page.should have_link "/movies/"+m.id
  inValueList.each do |k|
    p'??'
    p page.find("#movies tbody td").inspect
  assert  page.has_css?("#movies tbody td",:text=>k)  
  end
  
  #page.find("#movies tbody td")#.has_text("PG")
  end

end
Then /^the following ratings should be (un)?checked: (.*)/ do |unchecked,rating_list|
#pending # express the regexp above with the code you wish you had
  lst=rating_list.split(',')
  lst.each do |r|
    cbn=checkboxName("ratings_",r)
    field_checked = find_field(cbn)['checked']

    if (unchecked==true)then
      #lst.each{|r|  step "When I uncheck "+r+(checkboxName("ratings_",r))}
      if field_checked.respond_to? :should
        field_checked.should be_false
      else
        assert !field_checked
      end
    else
      if field_checked.respond_to? :should
        field_checked.should be_true
      else
        assert field_checked
      end
    end
  end
end

