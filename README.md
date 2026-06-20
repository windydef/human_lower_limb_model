# 3-Joint Passive Model of the Human Lower Limb

Biomodeling course assignment modeling the human lower limb as a **3-segment (hip–knee–ankle) passive linkage**, deriving its equations of motion via the **Lagrangian method**, and simulating the dynamics with **4th-order Runge-Kutta**. Passive joint torque follows a Hill-type muscle-model formulation.


## Overview

The lower limb is modeled as three rigid segments (thigh, shank, foot) connected by three joints (hip θ₁, knee θ₂, ankle θ₃). The pipeline:

1. Define segment kinematics (centers of mass, positions, velocities) from joint angles.
2. Build kinetic energy `Eₖ` and potential energy `Eₚ`, form the Lagrangian `L = Eₖ − Eₚ`.
3. Apply the Euler–Lagrange equation per joint to get torques, assembled into the matrix form `M(θ)θ̈ + C(θ,θ̇)θ̇ + G(θ) = τ`.
4. Passive joint torque `τ_p` from a Hill-type model drives the system.
5. Integrate numerically with RK4 (step size h = 0.001) to evolve θ and θ̇ over time.

The GUI lets the user set initial hip/knee/ankle angles and animates the limb reaching a resting (steady-state) posture.

## Model components

### Passive joint torque
```
τ_p = −c·θ̇ + k₁·e^(−k₂(θ−φ₁)) + k₃·e^(k₄(θ−φ₂))
```

**Passive joint torque parameters (Table 3.1):**
| Joint | c | k₁ | k₂ | k₃ | k₄ | φ₁ | φ₂ |
|---|---|---|---|---|---|---|---|
| Hip | 3.09 | 2.6 | 5.8 | 8.7 | 1.3 | −10° | 10° |
| Knee | 10.0 | 6.1 | 5.9 | 10.5 | 21.8 | 10° | 67° |
| Ankle | 0.943 | 2.0 | 5.0 | 2.0 | 5.0 | −15° | 25° |

### Skeletal segment parameters (Table 3.2a)
| Segment | Length (m) | Mass (kg) | CoG (% length) | Moment of Inertia (kg·m²) |
|---|---|---|---|---|
| Thigh | 0.383 | 6.86 | 0.42 | 0.133 |
| Shank | 0.407 | 2.76 | 0.41 | 0.048 |
| Foot | 0.149 | 0.89 | 0.40 | 0.004 |

### Muscle model parameters (Table 3.2b)
| Muscle | F_max (N) | l_opt (m) | C_PD (N·s/m) | k_PE | Moment arm (m) |
|---|---|---|---|---|---|
| Iliopsoas | 1100 | 0.35 | 275 | 5.85 | 0.132 (Hip) |
| BFLH | 2750 | 0.46 | 275 | 4.10 | 0.054 (Hip), 0.049 (Knee) |
| BFSH | 100 | 0.29 | 200 | 1.60 | 0.049 (Knee) |
| Rectus femoris | 1800 | 0.48 | 300 | 5.40 | 0.049 (Hip), 0.025 (Knee) |
| Gastroc. med. | 1150 | 0.56 | 275 | 8.25 | 0.050 (Knee), 0.040 (Ankle) |
| Soleus | 2150 | 0.35 | 200 | 6.50 | 0.036 (Ankle) |
| Tibialis Anterior | 1650 | 0.30 | 200 | 1.30 | 0.023 (Ankle) |

## Experiments

RK4 step size h = 0.001. The limb is released from an initial posture and settles to steady state.

### Standing position
| # | Initial Hip / Knee / Ankle | Iterations to steady state |
|---|---|---|
| 1 | 40° / 20° / −5° | 1236 |
| 2 | 20° / 20° / −5° | 1263 |
| 3 | 20° / 20° / 0° | 1061 |
| 4 | 20° / 50° / −5° | 1056 |

### Sitting position
| Setup | Iterations |
|---|---|
| Hip fixed at 90° (seated) | 1318 |

## Conclusions (as reported)

- The 3-joint passive limb can be modeled with a mechanical/Lagrangian formulation and integrated using RK4.
- The system settles to a steady-state posture governed by the hip angle.

## References

(Cited inline in the source: Nurmianto 2004; Cailliet 2005; "Alwi, 2013" for the Runge-Kutta accuracy claim. No formal reference list.)

---

## Author

**Windy Deftia M**  
Created in: 2018

Biomedical Engineering  
Institut Teknologi Sepuluh Nopember (ITS)