#!/usr/bin/env cbqn

# Written after finishing the "Combinators" tutorial, although not fully
# digesting the end (how do I read +˜⊸+˜´∘⌽, what is ·, for example).

e1 ← ⟨
  "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"
  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
⟩
colors ← "red"‿"green"‿"blue"
targets ← 12‿13‿14


# Taken from BQNcrate 
# Split list 𝕩 at any sequence of characters in 𝕨
Split ← {𝕨 ((⊢-˜¬×·+`»⊸<)∘∊˜⊔⊢) 𝕩}

# ⊐ index of, ↓ drop N
GameData ← ↓˜⟜(+⟜1∘⊐⟜':')
# Drop the ⟨⟩ at the front, which comes from the space
Records ← (1⊸↓", "⊸Split)¨ ∘ (";"⊸Split)

# I'm sure I could do this better if I knew how to reshape
# stuff
# ⊏ select, colors after number so +1
RoundNums ← {(2×↕2÷˜≠𝕩) ⊏ 𝕩}
RoundCols ← {(1+ 2×↕2÷˜≠𝕩) ⊏ 𝕩}
# Count the color 𝕨 in a round 𝕩 ⟨ "3" "blue" "4" "red" ⟩
RoundCount ← {•ParseFloat¨ (𝕨⊸≡¨ RoundCols 𝕩) / RoundNums 𝕩}
# Maximum count of color 𝕨 in a game 𝕩 ⟨round, round, ...⟩
GameMax ← {⌈´ ∾ 𝕨⊸RoundCount¨ 𝕩}
ColorCount ← {GameMax⟜𝕩¨ colors}

PossibleGame ← ∧´ targets ≥ ColorCount
Part1 ← {+´ (PossibleGame∘Records∘GameData¨𝕩) / (1+↕ ≠𝕩)}

•Show ⟨"Example Part 1", Part1 e1⟩ 

Power ← ×´ ColorCount
•Show ⟨"Example Part 2", +´ Power∘Records∘GameData¨ e1⟩ 

# Thoughts:

# We've got cbqn! How to get https://github.com/x86y/beacon eludes me. It
# mentioned `nix` so I've setup a nix environment via devcontainers. It was only
# when I got that working did I notce that it uses flakes, so I've no idea how
# to integrate it.

# So in the end, welp, I've done the editing in BQNPAD again, taking care not to
# exceed the character limit. 

input ← •FLines "inputs/day2.txt"
•Show ⟨"Part 1", Part1 input⟩ 
•Show ⟨"Part 2", +´ Power∘Records∘GameData¨ input⟩ 