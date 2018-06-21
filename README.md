# nhl_draft_classifier-
Examining the 1995-2017 NHL Drafts 

The draft can alter the destiny of any NHL team with good scouting, analytics, and of course a healthy dose of luck. For over ten seasons, draft picks like Sidney Crosby and Alex Ovechkin continue to power the Stanley Cup hopes of the Penguins and Capitals.

This leads to the question of how valuable is a first round NHL draft pick? And further, how does a first round selection compare to a third rounder or fifth rounder?

On a basic level, we can compare NHL draft picks through longevity (games played per season) and points per season. However, we encourage other analysts to explore other metrics such as point shares, which could provide a better snapshot of a draft pick’s overall value (on an offensive and defensive level).

For this analysis, we looked at draft selections between 1995 through 2017 via Hockey Reference. Since the 1995 NHL draft, selected picks posted a median of 16.8 games played per season (GP/season) and a median of 2.83 points per season.

Unsurprisingly, we found that it pays for NHL teams to stack picks in the first round. A little over 50% of first round picks averaged over the third–quartile of games played per season (for all draft rounds). Interestingly, only 18.6% and 15.3% of second and third round selections were able to top this mark.

Further, 25.3% and 28.1% of second and third round picks played 16.8 games or more per season (median games played per season among all draft round selections) but only slightly more than the six, seventh, and eighth round selections.

On the flip side, six, seventh, eighth, and ninth rounds picks (no longer a round) were far more likely to never play a single NHL game. Later round selections are notoriously hard to scout and typically don't make much of a splash in the NHL. 

We also created a multinomial regression model for measuring the probability that NHL draft picks land in the elite, good, average, or below replacement groups based on the average games played per season. Multinomial logistic regression is a classification method that generalizes logistic regression to multi-class problems (two or more classes).

Read Here: https://beyondtheaverage.wordpress.com/2018/06/21/how-valuable-are-first-round-draft-nhl-picks/
