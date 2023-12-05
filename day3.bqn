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

# From BQNcreate: Pad with a layer of fill elements on all sides
Pad ← (⊢↑˝·≍⟜¬2+≢)

GetSymbols ← {¬".0123456789"∊˜𝕩}⊸/⍷∘∾
symbols ← Pad (GetSymbols e1) ∊˜ >e1
IsDigit ← {('0' ≤ 𝕩) ∧ (𝕩 ≤ '9')}
digits ← Pad (IsDigit×-⟜'0') >e1 

# We need to pad these because Grow wraps the grid
parsed ← symbols ⋈¨ digits

# Adapted from BQNcrate GoL to just sum the neighbours to 1 step propogate symbols
Grow ← {0<⊑+˝⥊⌽⟜𝕩¨⋈⌜˜¯1‿0‿1}
# Cull symbols where digits is 0, padding is always culled
Cull ← {
  s‿d ← 𝕩
  (0≠s×d)‿d
} 
# Spread symbols left and right
Spead ← {
  s ← ⊑¨ 𝕩
  neighbourhood ← ⌽⟜s¨⋈⌜˜¯1‿0‿1
  spread ← ⊑0<+˝˘ 1↑1↓ neighbourhood
  spread ⋈ ¨ 1⊑¨ 𝕩
}
Harvest ← {
  s‿d ← 𝕩
  d ×⟜s ↩
  (d > 0)⊑'.'‿('0'+d)
} 

# Adapted BQNCrate split for digits only
SplitDigits ← {((⊢-˜¬×·+`»⊸<)∘¬∘IsDigit˜⊔⊢) 𝕩}
MaxDigitLen ← {⌈´ ≠¨ ∾ SplitDigits¨ 𝕩}

init ← Cull¨ Grow ⌾ (⊑¨) parsed
# If we grew into a digit, we need to spread until we reach the entire number
h ← Harvest¨ Cull¨∘Spead⍟(1-˜MaxDigitLen e1) init

# WIP, now to unravel and parse as floats





# Thoughts:

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

input ← •FLines "inputs/day3.txt"
# •Show ⟨"Part 1", input⟩ 
# •Show ⟨"Part 2", input⟩ 