#!/usr/bin/env cbqn

# Part 1 Initial Idea:
# Build a table with headings:
# [ "Hand", "Bid", "Hand Score", "Card Score"]
# "Card Score" should be equivilent to comparing for the highest consecutive
# hand. Then sort with ⍋ ∨ ⍒.

e1 ← ⟨
  "32T3K 765"
  "T55J5 684"
  "KK677 28"
  "KTJJT 220"
  "QQQJA 483"
⟩

Split ← {((¯1+⊢×·+`»⊸<)¬𝕩=𝕨)⊔𝕩}
Parse ← ⍉∘>•ParseFloat⌾(1⊸⊑)∘(' '⊸Split)¨

hands ← ⌽⟨
  ⟨5⟩
  ⟨4, 1⟩
  ⟨3, 2⟩
  ⟨3, 1, 1⟩
  ⟨2, 2, 1⟩
  ⟨2, 1, 1, 1⟩
  ⟨1, 1, 1, 1, 1⟩
⟩
cards ← "23456789TJQKA"

# From BQNcrate: Count of occurrences of each unique major cell
CountOccurances ← /⁼⊐
ScoreHand ← ⊑hands⊒⋈ ∘ ∨∘CountOccurances
# 13 Cards -> Base 13
ScoreCards ← (13⊸×⊸+˜´∘⌽) cards⊸⊐
# Hands of 5 -> (ScoreHand 𝕩) × 13×5 
Score ← (ScoreHand((13⋆5)⊸×⊸+)ScoreCards)
Part1 ← {
  [c,b] ← Parse 𝕩
  # ⍋ (Grade) gives the index if sorted, which is exactly what we need
  # Just add 1 and you're golden. 
  +´ b × 1+⍋ Score¨ c
}
•Show ⟨"Example Part 1", Part1 e1⟩ 

# Part 2 Initial Idea:
# Calculate the hand without jokers, then add 1 to the highest group before
# scoring.

cardsJ ← "J23456789TQKA"
ScoreHandJ ← {
  "JJJJJ"≡𝕩 ? 6 ;
  js ← +´'J'= 𝕩
  not_js ← 'J'⊸≠⊸/ 𝕩
  j_h ← js+⌾⊑ ∨∘CountOccurances not_js
  ⊑hands⊒⋈ j_h
}
ScoreCardsJ ← (13⊸×⊸+˜´∘⌽) cardsJ⊸⊐
ScoreJ ← (ScoreHandJ((13⋆5)⊸×⊸+)ScoreCardsJ)
Part2 ← {
  [c,b] ← Parse 𝕩
  # ⍋ (Grade) gives the index if sorted, which is exactly what we need
  # Just add 1 and you're golden. 
  +´ b × 1+⍋ ScoreJ¨ c
}
•Show ⟨"Example Part 2", Part2 e1⟩ 

# Initial Thoughts:

# Trying out https://bqn.funmaker.moe/ today to replace BQNPAD. There's a bunch
# of nify features but the big one is their glyph hilighting.

# Skipping 5 to finish 3 yesterday, I've not had much time to keep reading but
# I've come across ⍋ and ⍒ when searching BQNcrate. The stability example looks
# like a perfect way to solve today's problem.
# https://mlochbaum.github.io/BQN/doc/order.html#stability

# Post Part 1 Thoughts:

# When defining the card score I had the idea to map the cards into base 13,
# which works out pretty well. This made me realise that the hand score can also
# be included, so the order is completely predetermined in parallel.

# Piecing together the solution in Part1 could have been better, that's pretty
# brute forced. I went for ⌾ because I couldn't figure out how to vstack so
# that required me to practice defining Score as a train.

# All in all, I need to take a deeper look at ⍋ and ⍒.

# Post Part 1 Thoughts:

# Not the cleanest thing in the world, a lot of copy and pasting to change a few
# things. ScoreHandJ is pretty ugly all things said, but it works! 

# https://bqn.funmaker.moe/'s glyph highlighting is really nice, and I've been
# able click less symbols. That said I'm not sure if I'm remembering the
# shortcut or just the glyph location, just as I did with BQNPAD. 

# Without tab autocomplete there's less memory for symbol names, which has it's
# good and bad side. I'm still going to stick with it though, in hopes of 
# being able to shell out symbols without thought.

# As an idea, maybe popping up the keymap as a keyboard will form a better
# association? 
# https://mlochbaum.github.io/BQN/keymap.html

# I acidentally pressed Ctrl s a dozen times, saving the file. This is a minor
# annoyance, but also the highest praise an editor can get - it's so good that
# I'm Ctrl s ing out of muscle memory. 

# The split window is really nice, and mirrors having a code window and
# terminal. Being able to keep the code window in a fixed location whilst also
# seeing the output was a great decision. The only mild annoyance is having to
# use the mouse to expand/contract the window - maybe a fold-up output? 

# The other thing to factor is the live preview. I do miss it a bit, but at the
# same time it forces me to think thorugh a problem before checking the output
# or getting distracted by errors.

# I couldn't figure out how to read input.txt so I eventually copied it back to
# my local editor. My go-to is •FLines, so without it a lot of my code
# assumptions break.

# Rapid fire now:
# - Ctrl / doesn't add a space, and doesn't uncomment indented comments. Meh,
#   a style thing.
# - The data is not stored in the URL (so no accidentally corrupting the page
#   with too much data, but also no sharing links)

# That's about it, my vscode font is still broken is tab auto-complete and has
# spacing issues in the terminal, whilst beacon doesn't seem that easy to
# install. This is a good local maximum, and funmaker seems interested in
# continuing to improve it.

# Now to take a deeper read about ⍋ and ⍒.

input ← •FLines "inputs/day7.txt"
•Show ⟨"Part 1", Part1 input⟩ 
•Show ⟨"Part 2", Part2 input⟩ 