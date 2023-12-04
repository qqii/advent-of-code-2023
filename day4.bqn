#!/usr/bin/env cbqn

# Day 3 and how to use arrays in BQN is kicking my ass, but day 4 deceptivly
# simple, so I'm skipping ahead. Not even going to read and more docs, so I'm
# still at finishing "Quick Start". 

e1 ← ⟨
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19"
  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1"
  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83"
  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36"
  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
⟩

# From BQNCrate: Split 𝕩 at occurrences of separators 𝕨, removing the separators
SplitSep ← {𝕨 ((⊢-˜¬×·+`»⊸<)∘∊˜⊔⊢) 𝕩}
# dzaima again comes to explain:
# (⊢-˜¬×·+`»⊸<)
#    ≡
# {𝕩 -˜ (¬𝕩) × +` (»𝕩) < 𝕩}
# buy I need to work through why " " SplitSep "  x" ≡ ""‿"x"
SplitSep0 ← {
  ss ← 𝕨 SplitSep 𝕩
  {0≠≠¨ ss}/ss
}

Parse ← {
  wc ← 1↓":|"⊸SplitSep0 𝕩
  Parse ← •parseFloat¨ " "⊸SplitSep0
  winners ← Parse ⊑wc
  card ← Parse 1⊑ wc
  winners‿card
}
Points ← {⌊2⋆1-˜+´(1⊑𝕩) ∊ ⊑𝕩}
Part1 ← +´ Points∘Parse¨
•Show ⟨"Example Part 1", Part1 e1⟩ 

Matches ← {+´(1⊑𝕩) ∊ ⊑𝕩}
Zeros ← 0⥊˜⊢
Part2 ← +´{
  p2 ← Matches∘Parse¨ 𝕩
  Win ← {
    # very not in the spirit, capturing p2 and all that
    (Zeros 𝕨) ∾ (1 + Zeros 𝕩) ∾ (Zeros (𝕨 -˜ 𝕩 -˜ ≠p2))
  }
  
  card ← ↕≠p2
  # Build this in perp for a fold, but I need the card index...
  tagged ← ⟨1+Zeros≠p2⟩ ∾ (card ⋈¨ {(1+↕≠𝕩) Win¨ 𝕩} p2)

  Go ← {
    cards ← 𝕨
    i‿won ← 𝕩
  
    cards + won × i⊑cards
  }
  # left fold via ˜´⌽
  Go˜´⌽ tagged
}
•Show ⟨"Example Part 2", Part2 e1⟩

# Thoughts:

# Part 1 wasn't too bad, but I need to study SplitSep more. Luckily grhkm
# asked about it and dzaima has come to the rescue to break it down. 

# Part 2 I really forced a fold. There must be a more idiomaic way using ↩ and
# ⍟, or even a way to do it without capturing the number of cards in Win...?

input ← •FLines "inputs/day4.txt"
•Show ⟨"Part 1", Part1 input⟩ 
•Show ⟨"Part 2", Part2 input⟩ 