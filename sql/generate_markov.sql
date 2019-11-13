with recursive
  "markov_chain"("word") as (
    -- start with a random null-initiated bigram,
    -- this is the start of a message
    (select "next" as "word"
     from "ngrams"
     where "corpus" = :corpus and "current" is null
     order by random() limit 1
    )
    union all
		-- 2. shuffle the bigrams and pick a random word which has followed the first
		--    word before. Probability of choice is determined by number of occurances
		--    in the text, since it's random sorting
		-- 3. Finish when we select a word with a null RHS
    (select "next" as "word"
     from "ngrams" join "markov_chain" on "corpus" = :corpus and "word" = "current"
     order by random() limit 1
    )
  )

select string_agg("word", ' ') as "result" from "markov_chain"
