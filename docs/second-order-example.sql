with recursive

  -- split each message into a text array
  "input" as (
    select "id", "corpus", array_remove(regexp_split_to_array("text", '\s+'), '') as "words"
    from "text_inputs"
    where "corpus" = 'christchurch'
  ),

  "ngrams" as (
    select
      "input"."id" as "input_id",
      "seq",
      nullif(concat_ws(' ', "words"["seq"-1], "words"["seq"]), '') as "current",
      "words"["seq"+1] as "next"
    from "input", generate_series(0, array_length("words", 1)) as "seq"
  ),

  "markov_chain"("current", "prev") as (
    -- start with a random null-initiated bigram,
    -- this is the start of a message
    (select "ngrams"."next" as "current", null as "prev"
     from "ngrams"
     where "ngrams"."current" is null
     order by random() limit 1
    )
    union all
    -- 2. shuffle the bigrams and pick a random word which has followed the first
    --    word before. Probability of choice is determined by number of occurances
    --    in the text, since it's random sorting
    -- 3. Finish when we select a word with a null RHS
    (select "ngrams"."next" as "current", "markov_chain"."current" as "prev"
     from "ngrams" join "markov_chain" on "ngrams"."current" = concat_ws(' ', "markov_chain"."prev", "markov_chain"."current")
     where "ngrams"."next" is not null
     order by random() limit 1
    )
  )

--select * from input;
--select * from ngrams;
--select * from markov_chain;
select string_agg("current", ' ') as "result" from "markov_chain"
;
