# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
  # each returned element will be a hash whose key is the table header.
  # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
#assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
def checkboxName(prefix,suffix)
  (prefix+""+suffix).tr('"', "")
end

When /I DEPRECATED (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
# HINT: use String#split to split up the rating_list, then
#   iterate over the ratings and reuse the "When I check..." or
#   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  lst=rating_list.split(',')
  lst.each do |r|
    cbn=checkboxName("ratings_",r)
    if (uncheck=~/un/)then
      uncheck(cbn)
    else
      check(cbn)
    end
  end
end

Given /I (un)?check the following ratings: (.*)/ do |uncheck,rating_list|
  lst=rating_list.split(',')
  lst.each do |r|
    cbn=checkboxName("ratings_",r)
    if (uncheck=~/un/)then
      uncheck(cbn)
    else
      check(cbn)
    end
  end
end

Then /I should see (no)?\s?movies with the following ratings: (.*)/ do|no,rating_list|
  lst=rating_list.split(',')
  inValueList=lst.map{|r| r.to_s.tr('"','')}
  nodeTextList=page.all(:css,"#movies tbody tr td:first-child+td").map{|el| el.text}
  if no=~/no/ then
    inValueList.each do |k|
      assert nodeTextList.select{|el| el=~/^#{k}$/}.count ==0,"Found  movie with rating "+k.to_s
    end
  else
    inValueList.each do |k|
      assert nodeTextList.select{|el| el=~/^#{k}$/}.count >0,"Found no movie with rating "+k.to_s
    end
  end

end
Then /^the following ratings should be (un)?checked: (.*)/ do |unchecked,rating_list|
  lst=rating_list.split(',')
  lst.each do |r|
    cbn=checkboxName("ratings_",r)
    field_checked = find_field(cbn)['checked']
    if (unchecked=~/un/)then
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

Given /^"([^"]*)" is highlighted$/ do |tag_text|
# #movies thead tr th:first-child a
  sort_by_col_header=page.all(:css,"#movies thead tr th a").select{|el| el.text=~/^#{tag_text}$/}
  p '*'
  p sort_by_col_header
  p sort_by_col_header[0].path unless sort_by_col_header[0]==nil
  sort_by_col_header[0].click unless sort_by_col_header[0]==nil
  p '*'
  highlighted_column_names=[]
  highlighted_column_names=page.all(:css,"#movies thead tr th.hilite a").select{|el| el.text=~/^#{tag_text}$/}
  assert highlighted_column_names.count==1, "No column header is highlighted!"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
#  ensure that that e1 occurs before e2.
#  page.content  is the entire content of the page as a string.
  #assert false, "Unimplmemented"
  #p page.body
  row_list=page.all(:css,"#movies tbody tr td")
  #p page.all(:css,"#movies tbody tr td:first-child+td")
  #p row_list
  first_arg_cells=row_list.select{|el|el.text=~/^#{e1}$/}.map{|el| el.text}
  second_arg_cells=row_list.select{|el|el.text=~/^#{e2}$/}.map{|el| el.text}
  orig_list=first_arg_cells+second_arg_cells
  sorted_list=orig_list.sort
  #p'8'
  #p orig_list
  #p sorted_list
  
  assert orig_list==sorted_list,"Values are not sorted correctly"
end