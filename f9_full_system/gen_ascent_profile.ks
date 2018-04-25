SET l TO LEXICON().

SET t TO 0.

UNTIL t >= 200 {
  IF t > 30 {
    l:ADD(t, MIN(90, MAX(-1/2 * (t - 30) + 90, 0))).
  } ELSE {
    l:ADD(t, 90).
  }
  SET t TO t + 1.
}

WRITEJSON(l, "pitch_lookup_table.json").
