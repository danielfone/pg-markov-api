require 'sequel'
require 'logger'

class MarkovChain

  SCHEMA_QUERY = File.read('sql/schema.sql')
  INSERT_QUERY = File.read('sql/insert_bigrams.sql')
  SELECT_QUERY = File.read('sql/generate_markov2.sql')

  DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

  def self.setup
    DB << SCHEMA_QUERY
  end

  def self.add(corpus, text)
    DB[INSERT_QUERY, corpus: corpus, input_text: text].insert
  end

  def self.clear(corpus)
    DB[:ngrams].where(corpus: corpus).delete
  end

  def self.generate(corpus)
    DB[SELECT_QUERY, corpus: corpus].first[:result]
  end

end
