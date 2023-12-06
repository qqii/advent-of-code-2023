#!/usr/bin/env cbqn

e1 ← ⟨
  "Time:      7  15   30"
  "Distance:  9  40  200"
⟩

Split ← {((¯1+⊢×·+`»⊸<)¬𝕩=𝕨)⊔𝕩}
Parse ← ⍉∘>(•ParseFloat¨1↓' '⊸Split)¨ 

Races ← {
  h ← ↕𝕩+1
  h × 𝕩-h
}
# Hmm, there should be a more idiomatic way without using ⊑ and ˝˘∘⍉
WaysToWin ← {
  +´ (⊑𝕩) < Races (⊑𝕨)
}
Part1 ← ×´ WaysToWin˝˘∘Parse
•Show ⟨"Example Part 1", Part1 e1⟩

•Show ⟨"Part 1", Part1 ⟨
  "Time:        38     94     79     70"
  "Distance:   241   1549   1074   1091"
⟩⟩
•Show ⟨"Part 2", Part1 ⟨
  "Time:        38947970"
  "Distance:   241154910741091"
⟩⟩

