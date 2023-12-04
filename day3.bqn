#!/usr/bin/env cbqn

# Written after finishing the final tutorial, and skimming the "Quick Start".
# Understanding arrays might have have been really useful, but I guess I'm out
# of luck as they seems to have really increased the difficulty this year to
# combat LLMs.

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

# Ah fuck. this idea is _wrong_
# Game plan:
#   Part 1: 
#     Somehow "467..114.." -> ⟨467, 467, 467, 0, 0, 114, 114, 114, 0, 0⟩
#   Part 2: 
#     Identify non digit and non . as 1, others as 0
#   Part 3:
#     Propagate all 1s in the part 2 grid in a moore neighbourhood
#   Part 4:
#     Multiply part 3 on part 1 and sum

# Part 1
# Symbols used (from ∧⍷∾ on input): #$%&*+-/=@ . 0123456789
symbols ← "#$%&*+-/=@"
# Not very idomatic ;(
IsDigit ← {('0' ≤ 𝕩) ∧ (𝕩 ≤ '9')}
# From BQNCrate: Split 𝕩 at occurrences of separators 𝕨, removing the separators
SplitSep ← {𝕨 ((⊢-˜¬×·+`»⊸<)∘∊˜⊔⊢) 𝕩}
LineNumbers ← •parseFloat¨ ({0≠≠¨𝕩}⊸/('.'∾symbols)⊸SplitSep)
NumberIndex1 ← {
  mask ← IsDigit 𝕩
  # sum reduce over the falling edge
  # add 1 to distinguish between 0s
  mask × 1+ +` (»mask) ∧ ¬mask
}
Part1 ← {⊑⟜(0∾(LineNumbers 𝕩))¨ (NumberIndex1 𝕩)}

# Part 2

GetSymbols ← >{∨´𝕩⍷symbols}¨¨

# Part 3
# Butchered from GoL found on BQNcrate
Propagate ← {⊑1=+˝⥊⌽⟜𝕩¨⋈⌜˜¯1‿0‿1} 

(>Part1¨ e1) × (Propagate∘GetSymbols e1)







# Thoughts:

# The quick start really shows off a lot more BQN that I ever thought existed!
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
•Show ⟨"Symbols: ", ∧⍷∾ input⟩
# •Show ⟨"Part 1", input⟩ 
# •Show ⟨"Part 2", input⟩ 