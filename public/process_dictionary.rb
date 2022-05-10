dict = File.read("dictionary.csv").split
processed = Hash.new{[]}
dict.each do |word|
  if word.length == 5
    processed[word[0]] += [word]
  end
end

File.write("processed_dictionary.json", processed.as_json)
# needs to be processed in node JS most likely