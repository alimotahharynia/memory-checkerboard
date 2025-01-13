# Delayed match-to-sample (DMS) task with checkerboard stimuli
This repository contains code for a Delayed Match-to-Sample (DMS) visual task experiment using Psychtoolbox. Participants are presented with checkerboard stimuli, tasked with memorizing patterns, and required to identify the correct pattern after a delay.

![Checkerboard](https://github.com/user-attachments/assets/75b94a75-cb32-46cf-8674-49d854ae481b)

## Overview of the Task
### Experiment Design
Participants perform a Delayed Match-to-Sample (DMS) task as follows:

-  Fixation Phase:
A central fixation point (0.26° visual angle) is displayed for 2 seconds.

-  Sample Presentation:
A 4x4 checkerboard pattern (4.83° × 4.83°) is presented.
6 to 10 squares are yellow, while the rest are red.
Participants are instructed to memorize the pattern.

-  Delay Phase:
The fixation point remains on screen for 0.5, 1, 2, 4, or 8 seconds (randomly selected per trial).

-  Test Phase:
Two checkerboards are presented side-by-side, 3° apart:
One is identical to the sample (sample probe).
The other differs by one swapped yellow/red square (location altered, not color).
Participants press the left or right arrow keys to identify the correct pattern.

-  Feedback:
Correct Response: Green disc (1.93°).
Incorrect Response: Red disc.
No Response in 4 Seconds: Blue disc.

### Trials and Blocks
-  Training Block:
10 trials for familiarization.

-  Experimental Blocks:
6 blocks with 30 trials each (total: 180 trials).
Each block includes 5 trials for each delay condition.

### Timing
-  Checkerboards remain on screen until:
A response is made, or
The 4-second response window expires.

## Features
-  Customizable Task Parameters:
Adjust number of trials, delay durations, square sizes, square color balances, and swap color numbers.

-  Real-Time Feedback:
Feedback is provided immediately after each response.

-  Results Logging:
Reaction times, performance, and square patterns and figures per each delay intervals and all are saved after each block.

## Requirements
-  Software
MATLAB: Required to run the code.
Psychtoolbox: Used for visual stimuli presentation and input handling.

## Installation
-  Clone the repository:
```bash
git clone https://github.com/alimotahharynia/dms-checkerboard.git  
```
## Citation
If you use this model in your research, please cite our paper:
```
Hojjati F, Motahharynia A, Adibi A, Adibi I, Sanayei M. Correlative comparison of visual working memory paradigms and associated models. Sci Rep. 2024 Sep 6;14(1):20852. doi: 10.1038/s41598-024-72035-5. PMID: 39242827; PMCID: PMC11379810.
```
```
Pourmohammadi A, Motahharynia A, Shaygannejad V, Ashtari F, Adibi I, Sanayei M. Working memory dysfunction differs between secondary progressive and relapsing multiple sclerosis: Effects of clinical phenotype, age, disease duration, and disability. Mult Scler Relat Disord. 2023 Jan;69:104411. doi: 10.1016/j.msard.2022.104411. Epub 2022 Nov 12. PMID: 36436396.
```
