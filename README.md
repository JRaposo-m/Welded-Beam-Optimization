# Welded Beam Optimization

Optimization of a welded beam design problem (SMA7) using classical 
gradient-based methods and genetic algorithms, developed as part of 
the Mechanical Systems Optimization course at FEUP.

## Problem Overview

The goal is to minimize the total manufacturing cost of a welded beam
subject to 15 structural constraints, including shear stress, bending 
stress, buckling load and deflection limits.

**Design variables:** weld height (h), weld length (l), beam height (t), beam width (b)

**Optimal solution found:** f* = 2.381 (in, lb units)

## Methods Implemented

### Classical Methods
- Augmented Lagrangian with Conjugate Gradient
  - Fletcher-Reeves variant → converged in 6 iterations
  - Polak-Ribière variant → converged in 11 iterations

### Genetic Algorithm
- Binary encoding (50 bits)
- SUS selection
- Uniform crossover
- Flip-bit mutation
- Dynamic penalty (Hadj-Alouane & Bean / Joines et al.)

## Results

| Method | f(x) | Time (s) | Iterations |
|--------|-------|----------|------------|
| Classical (FR) | 2.381 | 0.09s | 6 |
| Classical (PR) | 2.381 | 0.39s | 11 |
| Genetic Algorithm | 2.380 | 0.14s | 100 gen. |

## Technologies
- MATLAB

## Report
Full report available in `/report` (written in Portuguese).
