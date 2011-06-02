# CHANGELOG
	
## Search tweaks

### Problem: 'Planet H' not returning any results.

It should at least be matching 'Planet Hollywood'. Suspect that this is due to the term 'H' not being present after tokenizing the input text.
1. Set `minimum_match` to zero. This allows 'Planet' to match. The missing 'H' doesn't exclude 'Planet Hollywood'.
  - 'Adler Planetarium' is still scoring higher than 'Planet Hollywood', likely due to their both being scored the same based on NGrams.
 	11	
2. Index `organization_name` twice: as `text` and `text_substring`. This lets us give an extra boost to exact matches. 'Planet' now scores higher than 'Planetarium'.
3. Bring back some more strictness to the `minimum_match` -- setting it at 60% for now, because 'Planet H' introduces a lot of noise from matches on the 'H'.

## Problem: Misspelled 'Hard Rack' should also match 'Hard Rock'
Idea: this may be catchable using Solr's Spellcheck functionality. Solr 1.4.1 can provide hints for alternate spellings. Solr 3.1 should also be able to auto-collate corrected terms.
1. Starting with Spellcheck hints.
  - Updating configs as per http://blog.websolr.com/post/2748574298
  - Added Spellcheck support to the Sunspot Search DSL
  - Showing a simple collated query when there are no results.