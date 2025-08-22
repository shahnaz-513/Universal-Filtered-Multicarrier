# Universal Filtered Multi-Carrier (UFMC) Simulation in MATLAB

We simulated a **UFMC transmitter system** in MATLAB, based on the theoretical model of Universal Filtered Multi-Carrier modulation. UFMC is a modulation technique developed to overcome the limitations of **OFDM** (Orthogonal Frequency Division Multiplexing) and **FBMC** (Filter Bank Multi-Carrier).  

## Objective
- Understand and simulate the **UFMC transmitter system**.  
- Compare UFMC with OFDM and FBMC.  
- Visualize UFMC signal characteristics in both **time domain** and **frequency domain**.  
- Study the effect of system parameters (IFFT size, filter length, number of subbands).  

## UFMC Transmitter Steps
1. **Input data bits** per subband.  
2. **Modulation** using QAM/PSK (e.g., 16-QAM).  
3. **Serial-to-Parallel conversion** for IFFT processing.  
4. **N-point IFFT** - Converts to time-domain.  
5. **Parallel-to-Serial conversion**.  
6. **Subband filtering** using FIR filters.  
7. **Summation** of filtered subbands - Final UFMC signal.   

MATLAB script: `ufmcUpdated.m` - attached in the repository 
Project report: `UFMC.pdf` - attached in the repository

Effects of varying parameters 
- **IFFT size** - Larger size improves frequency resolution.  
- **Filter length** - Longer filters provide better subband isolation but increase complexity.  
- **Number of subbands** - More subbands give denser spectra but higher complexity.  

## Discussion
- UFMC successfully addresses OFDM’s cyclic prefix overhead and FBMC’s high complexity.  
- The MATLAB simulation matches theoretical expectations.  
- Parameter tuning (e.g., filter length, IFFT size) directly impacts spectral characteristics.  
