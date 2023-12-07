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
Parse ← •ParseFloat⌾(1⊸⊑)∘(' '⊸Split)¨

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

# From BQNcrate: Sort 𝕩 descending according to column 𝕨
SortBy ← (⊏⎉1⍒⊸⊏⊢)
#p ← Parse input
#s ← ⍋ Score∘⊑¨ p
#b ← 1⊑¨ p
Part1 ← {
  t ← >Score⌾⊑¨ Parse 𝕩
  st ← (⊏˘t)⍋⊸⊏t # From # https://mlochbaum.github.io/BQN/doc/order.html#stability
  b ← ⥊1↓⍉ st
  m ← 1+↕≠ b
  +´ b×m
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
  t ← >ScoreJ⌾⊑¨ Parse 𝕩
  st ← (⊏˘t)⍋⊸⊏t # From # https://mlochbaum.github.io/BQN/doc/order.html#stability
  b ← ⥊1↓⍉ st
  m ← 1+↕≠ b
  +´ b×m
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

input ← •FLines "inputs/day7.txt"
•Show ⟨"Part 1", Part1 input⟩ 
•Show ⟨"Part 2", Part2 input⟩ 