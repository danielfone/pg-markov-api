CREATE TABLE IF NOT EXISTS "text_inputs" (
  "id" serial,
  "corpus" text NOT NULL,
  "text" text,
  PRIMARY KEY ("id")
);
