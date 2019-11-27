DROP MATERIALIZED VIEW if exists "ngrams";

create materialized view "ngrams" as
with
  -- split each message into a text array
  "input" as (
    select "id", "corpus", array_remove(regexp_split_to_array("text", '\s+'), '') as "words"
    from "text_inputs"
  ),

  "bigrams" as (
    select
      "input"."corpus",
      "input"."id" as "input_id",
      "seq",
      "words"["seq"] as "current",
      "words"["seq"+1] as "next"
    from input, generate_series(0, array_length("words", 1)) as "seq"
  ),

  "trigrams" as (
    select
      "input"."corpus",
      "input"."id" as "input_id",
      "seq",
      nullif(concat_ws(' ', "words"["seq"-1], "words"["seq"]), '') as "current",
      "words"["seq"+1] as "next"
    from "input", generate_series(0, array_length("words", 1)) as "seq"
  )

select * from "bigrams"
union
select * from "trigrams";

-- covering index
create index on "ngrams" ("corpus", "current", "next");
