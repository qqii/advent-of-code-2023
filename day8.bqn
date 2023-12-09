#!/usr/bin/env cbqn

# Trying out namespaces and control flow today.
# https://mlochbaum.github.io/BQN/doc/namespace.html
# https://mlochbaum.github.io/BQN/spec/system.html#control
# https://mlochbaum.github.io/BQN/doc/control.html

# First and last have been swapped to better match input data where AAA and ZZZ are within the list somewhere.
e1 ← ⟨
  "RL"
  ""
  "ZZZ = (ZZZ, ZZZ)"
  "BBB = (DDD, EEE)"
  "CCC = (ZZZ, GGG)"
  "DDD = (DDD, DDD)"
  "EEE = (EEE, EEE)"
  "GGG = (GGG, GGG)"
  "AAA = (BBB, CCC)"
⟩
e2 ← ⟨
  "LLR"
  ""
  "ZZZ = (ZZZ, ZZZ)"
  "BBB = (AAA, ZZZ)"
  "AAA = (BBB, BBB)"
⟩

# Pretty print a block, for debugging purposes
PPrintB ← { (⊣≍˘𝕩⊸•ns.Get¨) •ns.Keys𝕩 }

Parse ← {
  # Help! How do I train?
  ParseNode ← (3⊸↑ ⋈ ((3⊸↑7⊸↓) ⋈ (3⊸↑12⊸↓)))
  path‿node_map ← (⊑⋈2⊸↓) 𝕩
  [nodes, node_dirs] ← ⍉>ParseNode ¨ node_map
  
  path ⇐
  start‿end ⇐ nodes⊐"AAA"‿"ZZZ"
  [left, right] ⇐ nodes⊐⍉>node_dirs
}
# 𝕨 is the output of Parse
# 𝕩 is a state space { steps, node } for steps taken and current node
Cond ← {
  data ← 𝕨
  state ← 𝕩
  data.end ≠ state.node
}
Step ← {
  data ← 𝕨
  state ← 𝕩

  path_ix ← (≠data.path)|state.steps
  dir ← ⊑path_ix↓data.path  

  {
    dir = 'L' ? 
      steps ⇐ state.steps + 1
      node ⇐ ⊑state.node↓data.left ;
      steps ⇐ state.steps + 1
      node ⇐ ⊑state.node↓data.right
  }
}
Part1 ← {
  data ← Parse 𝕩
  (data Step •_while_ Cond { steps ⇐ 0 ⋄ node ⇐ data.start }).steps
}
•Show ⟨"Example 1 Part 1", Part1 e1⟩
•Show ⟨"Example 1 Part 1", Part1 e2⟩

e3 ← ⟨
  "LR"
  ""
  "11A = (11B, XXX)"
  "11B = (XXX, 11Z)"
  "11Z = (11B, XXX)"
  "22A = (22B, XXX)"
  "22B = (22C, 22C)"
  "22C = (22Z, 22Z)"
  "22Z = (22B, 22B)"
  "XXX = (XXX, XXX)"
⟩

# Bah, I could make this take a function 𝕨 to get the start
ParseA ← {
  # Help! How do I train?
  ParseNode ← (3⊸↑ ⋈ ((3⊸↑7⊸↓) ⋈ (3⊸↑12⊸↓)))
  path‿node_map ← (⊑⋈2⊸↓) 𝕩
  [nodes, node_dirs] ← ⍉>ParseNode ¨ node_map
  
  path ⇐
  starts ⇐ /'A'=¯1⊑¨nodes
  ends ⇐ /'Z'=¯1⊑¨nodes
  [left, right] ⇐ nodes⊐⍉>node_dirs 
}
CondZ ← {
  data ← 𝕨
  state ← 𝕩
  ∨´ state.node ⍷ data.ends
}
Part2 ← {
  data ← ParseA 𝕩
  inits ← { steps ⇐ 0 ⋄ node ⇐ 𝕩 }¨ data.starts
  each ← (data⊸(Step •_while_ CondZ))¨ inits
}
#{𝕩 •ns.Get "steps"}¨
PPrintB¨ Part2 e3

# Part 1 Initial Thoughts:

# The input sequence is heckin' long, as is the number of nodes. There's
# probably a "smarter" algorithm at play here. Parsing this is going to be a
# bitch too. The 2nd example should give me a hint - there's a cycle going on
# there and if I can work out the properties maybe I can figure out a formula
# without having to deal with it.
# One question to consider, is if i'll reaching the end is odne on a multiple of
# the instructions or not.

# After Part 1:

# There's a bit to learn when it comes to namespaces. They seem pretty handy to
# keep things clean but also introduce quite a bit of boilerplate. 
# Not the most keen that my functions that use state before I get a chance to
# define it, and I'm guessing it's all dynamic. 
# It's really quite terse, which explains the desire to have short variable
# names.

# After writing the initial solution I tought it would be quite inefficient.
# Turns out not to be the case. Parsing was also far easier than expected - it's
# a lot eaiser when the data is structured by index and not by arbitary length
# seperators.

# Part 2 Initial Thoughts:

# The difficulty here will really depend on how many nodes end with A. If there are too many then there's probably a trick, but part A was deceptively simple. 

# The simple approach, which may be inefficient is to:

# 1. Find all that ends with A
# 2. Run the loop against each of them
# 3. Calculate the least common multiple between them

# bqn.js doens't support •FLines, but does support •GetLine.
# This snippet was kindly shared with me by funmaker
#input ← 1 ↓ ¯1 ↓ (⊢ ∾⟜< •GetLine)•_while_(@ ≢ ¯1 ⊑ ⊢) ⟨""⟩
#input ← •FLines "inputs/day8.txt"
#•Show ⟨"Part 1", Part1 input⟩ 
#•Show ⟨"Part 2", Part2 input⟩