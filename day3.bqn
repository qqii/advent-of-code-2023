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
# digits on two lines joining. 
# https://mlochbaum.github.io/BQN/doc/fill.html
init ← Cull¨ Grow ⌾ (⊑¨) parsed
fin ← Harvest¨ Cull¨∘Spread⍟(1-˜MaxDigitLen e1) init
•Show ⟨"Part 1", +´ Ints ⥊ fin⟩ 

# ========== Part 2
gears ← Pad '*'= >e1

# # https://github.com/dzaima/aoc/blob/master/2023/BQN/3.bqn
# Pre-identifying the part numbers that belong 
# togther at the start makes our lives much easier as we don't
# have to try to figure that out at a cellular automata level!
part_ix ← ¯1+(+`1∾1‿0⍷⊢)⌾⥊⊸× ' '≠digits
part_n ← •ParseFloat¨ part_ix⊔digits

Moore ← {⌽⟜𝕩¨⋈⌜˜¯1‿0‿1}

# These magical functions come from Marshall, aka mlochbaum, the creator of BQN
# There's all types of higher order array wrangling
# <⎉1⍉∘>∘⥊ # list variant, colapses internal shape information
# <⎉2⍉⍟2> # shape preserving variant
# =⊸{<⎉𝕨⍉⍟𝕨>𝕩} # generic shape preserving, in bqncrate
# Invert array of same-rank arrays, exchanging inner with outer axes
Magic ← {𝕨 <⎉2⍉⍟2> 𝕩}
Exactly2 ← {
  g ← ⊑1↓˘1↓ ⊑¨ 𝕩
  p ← ¯1⊸≠⊸/ ⍷ 1⊑¨ ⥊ 𝕩
  g∧2=≠p ? p ; ⟨⟩
}
Cleanup ← ⟨⟩⊸≢¨⊸/⍷∘⥊

p2 ← +´ (×´⊏⟜part_n)¨ Cleanup Exactly2¨ Magic Moore gears ⋈¨ part_ix
•Show ⟨"Part 2", p2⟩ 