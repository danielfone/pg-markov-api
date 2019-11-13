CREATE TABLE IF NOT EXISTS "ngrams" (
    "id" serial,
    "corpus" text NOT NULL,
    "current" text,
    "next" text,
    PRIMARY KEY ("id")
);

CREATE INDEX ON "ngrams" ("corpus", "current");
