#!/usr/bin/env cbqn

# First time using an array programming language.

# Written and executed in BQNPAD after finishing the "Expressions" and 
# "List manipulation" tutorials, with the help of a lot of searching.
# https://mlochbaum.github.io/BQN/tutorial/index.html

# Manually created by applying regex transformations in vscode.
# $ -> "
# ^ ->   "
e1 ← ⟨
  "1abc2"
  "pqr3stu8vwx"
  "a1b2c3d4e5f"
  "treb7uchet"
⟩
e2 ← ⟨
  "two1nine"
  "eightwothree" 
  "abcone2threexyz"
  "xtwone3four"
  "4nineeightseven2"
  "zoneight234"
  "7pqrstsixteen"
⟩

digits ← '0'+↕10
digit_words ← "one"‿"two"‿"three"‿"four"‿"five"‿"six"‿"seven"‿"eight"‿"nine"

# found on https://mlochbaum.github.io/bqncrate/
IsDigit ← {('0' ≤ 𝕩) ∧ (𝕩 ≤ '9')}
# / drop, numpy's arr[arr_of_bools]
GetDigits ← {(IsDigit 𝕩) / 𝕩}
FirstDigit ← {(⊏∘GetDigits¨ 𝕩)}
FirstLast ← {𝕩 ∾¨○FirstDigit ⌽¨ 𝕩}
•Show ⟨"Example Part 1", +´ •ParseFloat¨ FirstLast e1⟩

# Taken from https://github.com/mlochbaum/bqn-libs/blob/master/strings.bqn
# Usage: ⟨"cat"‿"red", "dog"‿"blue"⟩ ReplaceAll "My red cat"
# Replace each instance of a string in old with the corresponding
# string in new.
# Instances are non-overlapping, and earlier ones take precedence.
ReplaceAll ← { ⟨old,new⟩ 𝕊 str:
  ! (≠new) ≡ l ← ≠old
  "ReplaceAll: Can't replace empty" ! ∧´0<≠¨old
  match ← 1-˜ (l+1)|⌊´ (↕⊸-l) × old (1<≠∘⊣)◶⟨⊑⊸=,≠∘⊢↑⍷⟩¨ <str
  cont ← (-⟜1⌈≤⟜1×⊢)` match ⊏ (≠¨old)∾0
  keep ← ⋈⟜(⊏⟜str) / 0=cont
  insert ← (new⊏˜⊏⟜match)⊸(≠¨⊸/⋈∾∘⊣) / (0⊸<∧»⊸≤) cont
  ⍋⊸⊏´ keep ∾¨ insert
}

FirstLastIncWords ← {
  digits1 ← ⋈¨1↓digits
  # ReplaceAll only works for non overlapping, but
  # "3one8ncctmbsixeight_twone_gb" -> 31
  f_replace ← ⟨digit_words, digits1⟩⊸ ReplaceAll¨ 𝕩
  b_replace ← ⟨⌽¨digit_words, digits1⟩⊸ ReplaceAll¨ ⌽¨𝕩
  (FirstDigit f_replace) ∾¨ FirstDigit b_replace
}
•Show ⟨"Example Part 2", +´ •ParseFloat¨ FirstLastIncWords e2⟩

# Final thoughts:

# I'm sure the approach I took was pretty naive, and far from idomatic. I'm 
# suprised by how quickly I'm remebering the symbols and keyboard shortcuts. It
# was suprising how instinctivly I reached for ⊸, even though I wouldn't be
# able to explain the presidence rules. ⟜ still eludes me, but I'm sure I'll
# get there. 

# The mixture of symbol memory combined with BQNPAD's word completion made made
# pretty easy to express myself, but BQN's decision give symbols different words
# tripped me up a few times. ¯ = minus, ↕ = range/windows (rather than iota).

# BQNPAD also made my life a huge pain. Multiple times I accidentally closed the
# window, and couldn't reopen it. Since it stores the text as part of the URL,
# when I added the real input this made the URL too long and it wouldn't load.
# I need to get a dev environment set up so I can run BQN locally.

# The BQN resources also seem a lot sparser than APL. BQN is supposed to be the
# new hotness, but I'm not sure how much of that is hype. The comparison with
# other array languages (https://mlochbaum.github.io/BQN/doc/based.html) goes
# pretty over my head, so it's to be seen how much benifit I'll get from 
# starting with BQN.

input ← •FLines "inputs/day1.txt"
•Show ⟨"Part 1", +´ •ParseFloat¨ FirstLast input⟩
•Show ⟨"Part 2", +´ •ParseFloat¨ FirstLastIncWords input⟩