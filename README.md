# Welded Beam Optimization

Academic project for the Mechanical Systems Optimization course at FEUP (2025–26),
in collaboration with Diogo Morais and Nuno Pinto.
Supervisor: Prof. Carlos Alberto Conceição António

---

## Problem Description

The goal is to **minimize the total manufacturing cost** of a welded beam subject to 15 structural constraints, including limits on shear stress, bending stress, critical buckling load and maximum deflection.

The design variable vector is `x = {h, l, t, b}` (imperial units: *in*, *lb*, *psi*):

| Variable | Description | Bounds |
|----------|-------------|--------|
| `h` | Weld height/width | [0.125, 2.0] in |
| `l` | Weld length | [0.1, 10.0] in |
| `t` | Beam height | [0.1, 10.0] in |
| `b` | Beam width | [0.1, 2.0] in |

**Objective function:**
```
f(x) = 1.10471·h²·l + 0.04811·t·b·(14.0 + l)
```

**Starting point and theoretical optimum:**
```
x_start = {0.4000, 6.0000, 9.0000, 0.5000}  →  f_start = 5.3904
x*      = {0.2444, 6.2177, 8.2915, 0.2444}  →  f*      = 2.3810
```

---

## Methods Implemented

### Classical Methods — Augmented Lagrangian + Conjugate Gradient

The outer loop in `script_codigo.m` runs the **Augmented Lagrangian Method**: at each iteration it calls `calcular_conjugado` to minimise the Lagrangian for the current `(lambda, epsilon)`, then updates both multipliers and the penalty parameter:

```
lambda_i ← max(0, lambda_i + (2/epsilon) · g_i(x))
epsilon  ← rho · epsilon
```

The loop stops when `verifica_KKT` confirms the KKT conditions are satisfied.

The inner solver `calcular_conjugado.m` uses the **Conjugate Gradient Method**. The direction update uses **Fletcher-Reeves** by default:

```matlab
beta = norm(g_novo) / norm(g_antigo);                              % Fletcher-Reeves (default)
% beta = (g_novo' * (g_novo - g_antigo)) / abs(g_antigo' * g_antigo);  % Polak-Ribière
```

To switch to **Polak-Ribière**, comment line 38 and uncomment line 39 inside `calcular_conjugado.m`.

The line search follows the **Armijo condition** and box constraints are projected after every step:
```matlab
lb = [0.125; 0.1; 0.1; 0.1];
ub = [2.0; 10.0; 10.0; 2.0];
x  = min(max(x, lb), ub);
```

### Genetic Algorithm

A **binary-encoded** implementation that evolves a population of candidate solutions over generations, using:

- **Selection:** Stochastic Universal Sampling (SUS)
- **Crossover:** Uniform crossover with random binary mask (Pc = 0.9)
- **Mutation:** Flip-bit (Pm = 0.008)
- **Elitism:** top 30% of population preserved each generation
- **Dynamic penalty:** Hadj-Alouane & Bean (adaptive λ)

---

## Results

| Method | f(x) | Time (s) | Iterations / Generations |
|--------|-------|----------|--------------------------|
| Classical — Fletcher-Reeves | 2.381 | 0.09 | 6 |
| Classical — Polak-Ribière | 2.381 | 0.39 | 11 |
| Genetic Algorithm (best run) | 2.380 | 0.14 | 100 generations |

Both classical methods converged to the theoretical optimum with no constraint violations. The GA reached solutions practically coincident with the optimum, with minimal residual violations (max ≈ 0.005).

> Times include diagnostic metric collection (plots, entropy, population snapshots). Pure computation is faster.

---

## Repository Structure

```
SMA7-Welded-Beam/
│
├── classical_methods/
│   └── script_codigo.m     ← Main script (outer Augmented Lagrangian loop)
│
├── genetic_algorithm/
│   └── script_codigo.m     ← Main script (calls genetic_algorithm internally)
│
├── report/
│   └── Trabalho_de_OSM.pdf ← Full report (Portuguese)
│
└── README.md
```

---

## How to Run

### Requirements

- **MATLAB** R2020b or later
- No additional toolboxes required
- Each script is **self-contained** — just open and run the file in the corresponding folder

---

### Classical Methods

1. Open MATLAB and navigate to the `classical_methods/` folder:
```matlab
cd('path/to/classical_methods')
```

2. Run the script:
```matlab
script_codigo
```

At each outer iteration the script prints a convergence table to the terminal:
```
Iter |    h      l      t      b   |   La(x)   |  ||grad||  | max(g) | epsilon
```
When KKT conditions are satisfied it prints:
```
Condições KKT satisfeitas na iteração k.
Última solução: h=X.XXXX, l=X.XXXX, t=X.XXXX, b=X.XXXX
```

**To switch between Fletcher-Reeves and Polak-Ribière**, open `calcular_conjugado.m` and swap the commented lines around line 38–39:
```matlab
beta = (norm(g_novo)) / (norm(g_antigo));                              % Fletcher-Reeves (default)
% beta = (g_novo' * (g_novo - g_antigo)) / abs(g_antigo' * g_antigo); % Polak-Ribière
```

**Configurable parameters in `script_codigo.m`** (outer Augmented Lagrangian loop):

```matlab
% --- Problem constants ---
P         = 6000;        % Applied load (lb)
L         = 14;          % Beam length (in)
E         = 30e6;        % Young's modulus (psi)
G         = 12e6;        % Shear modulus (psi)
tau_max   = 13600;       % Max shear stress (psi)
sigma_max = 30000;       % Max bending stress (psi)
delta_max = 0.25;        % Max deflection (in)

% --- Starting point ---
x = [0.4; 6.0; 9.0; 0.5];

% --- Augmented Lagrangian ---
epsilon  = 0.1;          % Initial penalty parameter
lambda   = zeros(6,1);   % Initial Lagrange multipliers (one per active constraint)
max_iter = 100;          % Maximum number of outer iterations
ro       = 0.9;          % Reduction factor: epsilon ← ro · epsilon each iteration
```

**Configurable parameters in `calcular_conjugado.m`** (inner Conjugate Gradient loop):

```matlab
% --- Conjugate Gradient ---
tolerancia = 1e-4;   % Stopping tolerance on the gradient norm ‖∇La(x)‖
max_iter   = 500;    % Maximum number of inner CG iterations

% --- Line search (Armijo) ---
c     = 0.1;         % Initial step size scaling
gama  = 0.1;         % Sufficient decrease parameter
delta = 0.5;         % Step reduction factor (alpha ← delta · alpha on failure)

% --- Box constraints (projected after each step) ---
lb = [0.125; 0.1; 0.1; 0.1];
ub = [2.0;  10.0; 10.0; 2.0];
```

---

### Genetic Algorithm

1. Open MATLAB and navigate to the `genetic_algorithm/` folder:
```matlab
cd('path/to/genetic_algorithm')
```

2. Run the script:
```matlab
script_codigo
```

The script calls `genetic_algorithm(...)`, which runs the full evolutionary loop and returns all diagnostics. After all runs it produces:

- Summary table of the best result per run: merit, `f(x)`, number of violated constraints, stopping generation
- Detailed analysis of the best run:
  - Evolution of merit and `f(x)` of the best individual per generation
  - Evolution of all 4 design variables across generations
  - Residual penalty and evolution of the `λ` parameter
  - Population and elite distribution at generations `[10, 50%, 95%]` of `max_gen`
  - Shannon entropy per variable (genetic diversity over generations)

**Configurable parameters in `script_codigo.m`**:

```matlab
% --- Population ---
N_pop   = 30;        % Population size
N_elite = 9;         % Elite individuals preserved each generation (≈ 30% of N_pop)
n_runs  = 25;        % Number of independent runs

% --- Genetic operators ---
P_cross = 0.9;       % Crossover probability
P_mut   = 0.008;     % Bit-flip mutation probability per bit

% --- Binary encoding ---
n_decimals = 3;      % Decimal precision → 50 bits total
                     %   2 decimals → 36 bits
                     %   4 decimals → 64 bits
                     %   5 decimals → 76 bits
```

**Configurable parameters inside `genetic_algorithm.m`**:

```matlab
% --- Stopping criteria ---
max_gen     = 500;   % Maximum number of generations
eps_improve = 1e-6;  % Minimum merit improvement to reset the stall counter

% --- Dynamic penalty: Hadj-Alouane & Bean ---
lambda  = 10;        % Initial value of λ  (also try: 20, 25)
beta_1  = 1.2;       % Increase factor when best individual is infeasible
                     %   for Nf consecutive generations → lambda = lambda · beta_1
beta_2  = 1.1;       % Decrease factor when best individual is feasible
                     %   for Nf consecutive generations → lambda = lambda / beta_2
Nf      = max(50, round(max_gen/8, 0));
                     % Update frequency (auto-scaled with max_gen)

% --- Merit cap ---
C_max   = 100;       % Ensures Mer(x) = C_max - Aval(x) >= 0 for all individuals
```

---

## Problem Constants

| Symbol | Description | Value |
|--------|-------------|-------|
| P | Applied load | 6000 lb |
| L | Beam length | 14 in |
| E | Young's modulus | 30 × 10⁶ psi |
| G | Shear modulus | 12 × 10⁶ psi |
| τ_max | Maximum shear stress | 13.6 × 10³ psi |
| σ_max | Maximum bending stress | 30.0 × 10³ psi |
| δ_max | Maximum deflection | 0.25 in |

---

## References

1. C. C. António — *Optimization of Mechanical Systems: Fundamentals and Algorithms*, 2024
2. A. Hadj-Alouane & J. C. Bean — *A genetic algorithm for the multiple-choice integer program*, Computers & Operations Research, 1995
3. F. Herrera, M. Lozano & J. L. Verdegay — *Tackling real-coded genetic algorithms*, Artificial Intelligence Review, 1998
4. J. Joines & C. Houck — *On the use of non-stationary penalty functions to solve constrained optimization problems with genetic algorithms*, IEEE, 1994
5. S. S. Rao — *Engineering Optimization: Theory and Practice*, Wiley, 2019
