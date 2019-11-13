require 'sequel'

#
# "Hmm.. maybe load your data up into a solution."
#
class MarkovChain

  SELECT_QUERY = File.read('sql/generate_markov.sql')

  DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

  def self.setup
    Pathname.glob('sql/schema/**/*.sql') { |f| DB << f.read }
  end

  def self.add(corpus, text)
    DB[:text_inputs].insert(corpus: corpus, text: text)
    DB << 'refresh materialized view ngrams'
  end

  def self.clear(corpus)
    DB[:text_inputs].where(corpus: corpus).delete
  end

  def self.generate(corpus)
    DB[SELECT_QUERY, corpus: corpus].first[:result]
  end

end
