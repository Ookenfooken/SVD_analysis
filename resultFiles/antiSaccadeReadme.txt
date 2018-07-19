1. column - patient:
0 --> control
1 --> patient

2. column - subjectID: 
This doesn't correspond to the full subject ID. We are reading out the last 2 digits of the subject ID

3. column - target selection:
0 --> incorrect target selection
1 --> correct target selection
2 --> correct target selection, but initial saccade in opposite direction

4. column - saccade latency: 
initial saccade latency 

5. column - cumulative saccade amplitude:
sum of all saccade amplitudes

6. column - saccade number:
total number of saccades

7. column - absolute saccade accuracy:
Eucledian distance between eye end position and target position

8. column - horizontal saccade accuracy:
horizontal difference between eye end and target position
positive error: overshoot
negative error: undershoot

9. column - vertical saccade accuracy:
vertical difference between eye end and target position
positive error: landing point above the target
negative error: landing point below the target
