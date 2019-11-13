with
-- split each message into a text array
	"input" as (
		select array_remove(regexp_split_to_array(:input_text, '\s+'), '') as "words"
	),

	"bigrams" as (
	  select
	    words[seq] as "current",
	    words[seq+1] as "next"
	  from input, generate_series(0, array_length("words", 1)) as seq
	),

	"trigrams" as (
	  select
	    concat_ws(' ', words[seq-1], words[seq]) as "current",
	    words[seq+1] as "next"
	  from input, generate_series(0, array_length("words", 1)) as seq
	)

insert into "ngrams" ("corpus", "current", "next")
select :corpus, "current", "next"
from "bigrams"
union
select :corpus, "current", "next"
from "trigrams"
