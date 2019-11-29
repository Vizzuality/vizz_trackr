file = File.read(Rails.root.join('app', 'data', 'quotes.json'))

RANDOM_QUOTES = JSON.parse(file)
