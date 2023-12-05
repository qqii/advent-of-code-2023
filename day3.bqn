#!/usr/bin/env cbqn

# Written after day 4, because of a logical error with the first attempt. 

e1 ← ⟨
  "467..114.."
  "...*......"
  "..35..633."
  "......#..."
  "617*......"
  ".....+.58."
  "..592....."
  "......755."
  "...$.*...."
  ".664.598.."
⟩
e1 ↩ •FLines "inputs/day3.txt"

# From BQNcreate: Pad with a layer of fill elements on all sides
Pad ← (⊢↑˝·≍⟜¬2+≢)

GetSymbols ← {¬".0123456789"∊˜𝕩}⊸/⍷∘∾
symbols ← Pad (GetSymbols e1) ∊˜ >e1
IsDigit ← {('0' ≤ 𝕩) ∧ (𝕩 ≤ '9')}
digits ← { (⊑𝕩∊'0'+↕10) ? (𝕩) ; (' ') }¨ Pad >e1 

# We need to pad these because Grow wraps the grid
parsed ← symbols ⋈¨ digits

# Adapted from BQNcrate GoL to just sum the neighbours to 1 step propogate
# symbols
Grow ← {0<⊑+˝⥊⌽⟜𝕩¨⋈⌜˜¯1‿0‿1}
# Cull symbols where digits is 0, padding is always culled
Cull ← {
  s‿d ← 𝕩
  {d=' '?0;s}‿d
} 
# Spread symbols left and right
Spread ← {
  s ← ⊑¨ 𝕩
  neighbourhood ← ⌽⟜s¨⋈⌜˜¯1‿0‿1
  spread ← ⊑0<+˝˘ 1↑1↓ neighbourhood
  spread ⋈ ¨ 1⊑¨ 𝕩
}
Harvest ← {
  s‿d ← 𝕩
  s ? d ; '.' # just to see it better
} 

# Adapted BQNCrate split for digits only
SplitDigits ← {((⊢-˜¬×·+`»⊸<)∘¬∘IsDigit˜⊔⊢) 𝕩}
MaxDigitLen ← {⌈´ ≠¨ ∾ SplitDigits¨ 𝕩}

# Taken from dzaima's utils 
# https://github.com/dzaima/aoc/blob/master/2023/BQN/utils.bqn
Ints ← {•ParseFloat¨((¯1+⊢×·+`»⊸<)𝕩∊'0'+↕10)⊔𝕩}

# We've padded this already, so it's safe to ⥊ this without worrying about
# digits on two lines joining. Somehow we've lost the fill, so can't use
# SplitDigits
# https://mlochbaum.github.io/BQN/doc/fill.html
init ← Cull¨ Grow ⌾ (⊑¨) parsed
fin ← Harvest¨ Cull¨∘Spread⍟(1-˜MaxDigitLen e1) init
•Out "Part 1: " ∾ •Fmt +´ Ints ⥊ fin



# Thoughts:

# I struggled with this problem. A lot of this came down to lack of planning and
# just taking the head first approach. In both solutions I discarded vital
# information at the beginning, calculating something completely different!

# There's quite a lot going on this time, so I've skipped wrapping it up into a
# nice function and used ↩ instead. For on-offs, using captures can simplfy
# the expression, even if it isn't tactic or idiomatic.

# Original Pre-Thoughts:

# The Quick Start really shows off a lot more BQN that I ever thought existed!
# There's syntax to do pseudo-procedural programming! I wonder how much overlap
# there is with other array languages.

# I couldn't get beacon installed, so I'm giving up on that for now. Someone in
# the discord mentioned that you should install cbqn-replxx via nix to get the
# \ shortcuts. cbqn also has system commands such as )e in addition to
# additional system functions.
# (https://github.com/dzaima/CBQN/blob/master/docs/README.md)

# My current terminal font causes ⌾ to overlap with the next character, and I
# need a replacement to BQNPAD's list of characters but once those are sorted
# I can try moving to local development.