require 'csv'

lines = CSV.parse(File.read('valid_guesses.csv'), headers: true)
lines_array = []
lines.each do |line|
  lines_array << line["word"]
end

File.write('guess.json', lines_array)