#!/usr/bin/env python
# coding: utf-8

# # Wordle 1/6 🟩🟩🟩🟩🟩
# ## Get the daily wordle on your first guess
# 
# You can get the daily [Wordle](https://www.powerlanguage.co.uk/wordle/) on the first try using the ⬛🟨🟩  tweet distribution.
# 
# It turns out the ⬛🟨🟩  squares taking social media by storm contain enough information to correctly guess the daily Wordle on the first attempt each day.
# 
# We’ll do this by taking a sample of several thousand tweets per daily Wordle. This sample is saved in the dataset [benhamner/wordle-tweets](https://www.kaggle.com/benhamner/wordle-tweets). 
# 
# The Wordle source code contains 2,315 days of answers (all common 5-letter English words) and 10,657 other valid, less-common 5-letter English words.
# 
# We combine these to form a set of 12,972 possible words/answers.
# 
# We then simulate playing 3,500 Wordle games for each of these possible words, guessing based on the frequency of the word in the English language and the feedback received.
# 
# Then we take three measures to evaluate the observed distribution of ⬛🟨🟩  squares on Twitter according to our valid words.
# 
# The first is the frequency of each of the 243 possible 5-square combinations in the observed/simulated games. We rank all the valid words by cosine similarity between the simulated and observed distributions.
# 
# The second looks at the fraction of these 5-square combinations that occur right before the correct guess. Again, we rank valid words based on the cosine similarity distance between the observed and simulated distributions.
# 
# Finally, based on the valid words there’s invalid 5-square combinations for each possible answer. We rank valid words on the number of these invalid combinations we observe. Twitter data being noisy, there’s usually some invalid combinations for the correct answer.
# 
# We then generate our guess by taking the word with the best average rank across these three measures.
# 
# Since I started collecting Twitter data (Wordle 210-222), this method generated the correct Wordle answer on the first attempt every day!
# 
# The code below uses Twitter data and precomputed simulation distributions to answer the day’s Wordle. It uses the daily Twitter data processed by the notebook [benhamner/pull-wordle-tweets](https://www.kaggle.com/benhamner/pull-wordle-tweets). The notebook [benhamner/wordle-simulations](https://www.kaggle.com/benhamner/wordle-simulations) runs the Wordle simulations and precomputes invalid feedback square combinations.

# ## Code to guess the daily Wordle

# Importing the packages we need

# In[2]:


from collections import Counter
from itertools import product
import numpy as np
import pandas as pd
import pickle
import re
from scipy import spatial


# ### Assign each possible Wordle feedback result to a position in a vector
# 
# Wordle feedback results are five-character Unicode sequences like 🟩🟨⬛⬛⬛ (indicating the first letter is correct, the second letter is in the answer but in a different position, and the final three letters aren't in the answer) or 🟩🟩🟩🟩🟩 (indicating you got all letters right and the answer).
# 
# For each of the five characters, you learn one of three things:
# 
# - 🟩 - the letter is in the answer and in the correct position
# - 🟨 - the letter is in the answer but in a different position
# - ⬛ or ⬜ - the letter is not in the answer
# 
# This gives $3^5=243$ possible feedback results. We'll use 243-dimensional vector to capture these result distributions.
# 
# To move away from Unicode for simplicity, I reassign 🟩 to Y (yes), 🟨 to M (maybe), and ⬛ / ⬜ to N (no).
# 
# Note that all of these 243 possibilities aren't valid in practice. For example YYYYM will never be seen because if the first four letters are correctly placed and the fifth is also in the word, it will be correctly placed. But we can ignore this edge case for our purpose.

# In[3]:


vec_locs = sorted(["".join(x) for x in product("YMN", repeat=5)])
vec_locs[:5]


# ### Define helpful functions

# In[4]:


# Extract the Wordle result from a tweet, and remap the unicode feedback to Y/M/N
def wordle_guesses(tweet):
    text = (tweet.replace("Y", "y").replace("🟩", "Y")
                 .replace("M", "m").replace("🟨", "M")
                 .replace("N", "n").replace("⬛", "N").replace("⬜", "N"))
    guesses = re.findall("([YMN]+)", text)
    return guesses

def evaluate_guess_char(answer, guess, pos):
    if answer[pos]==guess[pos]:
        return "Y"
    unmatched_answer_chars = 0
    unmatched_guess_chars = 0
    this_guess_num = 0 
    for i in range(5):
        if answer[i]==guess[pos]:
            if answer[i]!=guess[i]:
                unmatched_answer_chars += 1
        if guess[i]==guess[pos]:
            if answer[i]!=guess[i]:
                unmatched_guess_chars += 1
                if i<pos:
                    this_guess_num += 1
    if this_guess_num<unmatched_answer_chars:
        return "M"
    return "N"

def evaluate_guess(answer, guess):
    return "".join(evaluate_guess_char(answer, guess, i) for i in range(5))

assert evaluate_guess("tools", "break")=="NNNNN"
assert evaluate_guess("tools", "tools")=="YYYYY"
assert evaluate_guess("tools", "tolls")=="YYNYY"
assert evaluate_guess("tools", "books")=="NYYNY"
assert evaluate_guess("tools", "broke")=="NNYNN"
assert evaluate_guess("tools", "yahoo")=="NNNMM"
assert evaluate_guess("tools", "bongo")=="NYNNM"
assert evaluate_guess("tools", "brook")=="NNYMN"
assert evaluate_guess("rates", "ranks")=="YYNNY"
assert evaluate_guess("rates", "apple")=="MNNNM"


# ### Load the outputs from our simulations
# 
# This loads the outputs we need from the simulation notebook [benhamner/wordle-simulations](https://www.kaggle.com/benhamner/wordle-simulations)
# 
# It includes:
# - Two groups of vectors corresponding to the result distribution for all the simulated games
# - The precomputed invalid results that wouldn't be seen for each possible valid world as the candidate answer
# - The set of valid words and answers from the Wordle source code

# In[8]:


with open("/content/drive/MyDrive/wordle/sim/vec_all.pickle", "rb") as f:
    v_all = pickle.load(f)

with open("/content/drive/MyDrive/wordle/sim/vec_ratio.pickle", "rb") as f:
    v_ratio = pickle.load(f)

with open("/content/drive/MyDrive/wordle/sim/invalid_results.pickle", "rb") as f:
    invalid_results = pickle.load(f)
    
with open("/content/drive/MyDrive/wordle/sim/answers.txt", "r") as f:
    answers = f.read().split("\n")

with open("/content/drive/MyDrive/wordle/sim/other_words.txt", "r") as f:
    other_words = f.read().split("\n")

words = answers + other_words
for answer in ["agora", "pupal", "lynch"]: # NYTimes version skipped these
    answers.remove(answer)


# # Load a daily sample of tweets
# 
# This sample is saved in the dataset [benhamner/wordle-tweets](https://www.kaggle.com/benhamner/wordle-tweets).

# In[10]:


df = pd.read_csv("/content/drive/MyDrive/wordle/tweets.csv")
df


# # Compute our daily Wordle guess
# 
# For each day with a tweet sample, we:
# 
# - Compute the distributions of Wordle results tweeted for that day
# - Compare this to the distributions for each possible word from out simulated games
# - Compare this to the precomputed invalid result list for each possible word
# - Rank the possible words according to three measures (two distributional and the invalid list)
# - Take the possibility that ranks best across these three measures as our daily guess

# In[13]:


results = []

for i in sorted(set(df["wordle_id"])):
    tweet_texts = df[df["wordle_id"]==i]["tweet_text"]
    
    games = [wordle_guesses(tweet) for tweet in tweet_texts]   
    
    all_counts = Counter(res for game in games for res in game if len(game)>=2 and game[-1]=="YYYYY")
    first_counts = Counter(game[0] for game in games if len(game)>=2 and game[-1]=="YYYYY")
    penultimate_counts = Counter(game[-2] for game in games if len(game)>=2 and game[-1]=="YYYYY")
    
    vec_all = [all_counts[res] for res in vec_locs]
    vec_first = [first_counts[res] for res in vec_locs]
    vec_penultimate = [penultimate_counts[res] for res in vec_locs]
    vec_ratio = [penultimate_counts[res]/(all_counts[res]+1e-6) for res in vec_locs]
    
    dists = {"all": [], "ratio": []}
    
    for key in v_all:
        dists["all"].append((spatial.distance.cosine(vec_all, v_all[key]), key))
        dists["ratio"].append((spatial.distance.cosine(vec_ratio, v_ratio[key]), key))
    
    dists["invalid"] = [(len([g for g in games if any(r in invalid_results[key] for r in g)]), key) for key in v_all]

    ranks = {}
    for d in dists:
        s = sorted(dists[d])
        ranks[d] = {s[i][1]: i for i in range(len(s))}
    
    overall = []
    for key in v_all:
        overall.append((sum(ranks[r][key] for r in ranks), key))
    
    my_guess = sorted(overall)[0][1]
    answer = answers[i]
    answer_rank = [x[1] for x in sorted(overall)].index(answer)
        
    results.append([i, my_guess, answer, answer_rank, overall, dists, ranks])
    feedback = evaluate_guess(answer, my_guess).replace("Y", "🟩").replace("M", "🟨").replace("N", "⬛")

    if answer==my_guess:
        feedback += " !!!!!!"
    else:
        feedback += " :(:( the actual answer ranked %d on my guess list" % (answer_rank)
    
    if i<max(df["wordle_id"]):
        print("For Wordle %d, my guess was %s. %s" % (i, my_guess, feedback))
    else:
        # Hide today's answer
        print("For today's Wordle %d, my result was: %s" % (i, feedback))


# In[12]:


# Unhide the output of this cell to reveal today's guess
print("For Wordle %d, my guess was %s. %s" % (i, my_guess, feedback))


# In[ ]:




