# simulator_reference_tuner.io
# DNA Melting Curve - Reference vs Simulation Tuner

## 🔗 Live Web App
You can run the PCR Simulator Reference Tuner here:

👉 https://jfbenigno.github.io/simulator_reference_tuner.io/

A comprehensive toolkit for analyzing, normalizing, and comparing DNA melting curves from qPCR experiments. This project enables researchers to validate simulated melting curves against experimental reference data through interactive web-based tools.

## 🧬 Overview

This toolkit provides a complete workflow for DNA melting curve analysis:
- **Normalization** of raw fluorescence data from qPCR instruments
- **Simulation** of theoretical melting curves using multiple algorithms
- **Comparison** between experimental references and simulations
- **Validation** tools for quality checking reference curves

## 📁 Project Structure

```
Reference_vs_Simulation_Tuner/
├── DNA_Melting - Reference_vs_Simulation_Tuner.html  # Main tuner application
├── melt-normalizer.html                               # Curve normalization tool
├── pcr_tuner_references_information.html              # Reference sequences documentation
├── meltDNA_ref_curves.js                              # Reference curve data library
├── meltingLib.js                                      # Core melting simulation algorithms
├── CSVs_for_Tuner_app/
│   ├── RAW CSV (not normalized)/                      # Original qPCR data
│   └── NORMALIZED CSV/                                # Processed 0-1 normalized curves
├── Integration for PHIX174/
│   ├── python_integration_code.py.html                # Integration script for derivative data
│   └── phiX174 CSV files                              # PhiX174 reference data
└── Quality Check For References/
    ├── meltDNA for PHIX174 Simulated Curves.R         # R script for DECIPHER validation
    └── Overlay R for Phongroup Reference Curves/      # Additional validation scripts
```

## 🚀 Getting Started

### Prerequisites

- Modern web browser (Chrome, Firefox, Safari, or Edge)
- For Python integration script: Python 3.x with pandas, numpy, scipy
- For R validation scripts: R with DECIPHER and Biostrings packages

### Quick Start

1. **Normalize Raw Data**
   - Open `melt-normalizer.html` in your web browser
   - Upload your raw qPCR CSV file (must contain Temperature and Fluorescence columns)
   - The tool automatically detects columns and normalizes to 0-1 scale
   - Download the normalized CSV for use in the tuner

2. **Run the Tuner Application**
   - Open `DNA_Melting - Reference_vs_Simulation_Tuner.html` in your browser
   - Select a reference strain from the dropdown (e.g., FCV_GX01-13, H1N1, PHIX174)
   - Upload your normalized CSV or use provided reference data
   - Adjust simulation parameters (algorithm, salt concentrations, cooperativity, etc.)
   - Compare experimental vs simulated curves visually
   - Evaluate goodness-of-fit metrics

3. **View Reference Information**
   - Open `pcr_tuner_references_information.html` to see:
     - Complete DNA sequences for all reference strains
     - Metadata (strain names, sources, Tm values)
     - Experimental conditions used

## 📊 Key Features

### 1. Melting Curve Normalization (`melt-normalizer.html`)

**What it does:**
- Normalizes raw qPCR fluorescence data to 0-1 scale
- Uses biochemically accurate formula: `fraction_melted = (maxF - F) / (maxF - minF)`
- Handles intercalating dye signals (SYBR Green, EvaGreen)
- Provides step-by-step biochemical explanations

**Input:** Raw CSV with temperature and fluorescence columns  
**Output:** Normalized CSV with temperature and fraction_melted (0-1)

**Key Points:**
- High fluorescence (low temp) = double-stranded DNA → 0 (not melted)
- Low fluorescence (high temp) = single-stranded DNA → 1 (fully melted)
- Tm (melting temperature) occurs at fraction_melted ≈ 0.5

### 2. Reference vs Simulation Tuner (`DNA_Melting - Reference_vs_Simulation_Tuner.html`)

**What it does:**
- Compares experimental reference curves with simulated predictions
- Supports 4 simulation algorithms:
  - **Independent**: Simple nearest-neighbor model
  - **Thermodynamic**: Mixed salt corrections (SantaLucia)
  - **Polymer**: Statistical mechanics approach
  - **Simple Sigmoid**: Basic sigmoidal approximation

**Features:**
- Real-time parameter tuning
- Interactive overlay plots
- Goodness-of-fit metrics (RMSE, R²)
- Export comparison results

**Parameters you can adjust:**
- Na⁺ concentration (mM)
- Mg²⁺ concentration (mM)
- Cooperativity factor
- Window size
- Algorithm-specific parameters

### 3. Pre-loaded Reference Strains

Available in `meltDNA_ref_curves.js`:

**Feline Calicivirus (FCV) Strains:**
- FCV_GX01-13
- FCV_UTCVM-H2
- FCV_TH_KP181, KP313, KP80, KP82, KP361
- Nobivac1_HCPCh

**Influenza Strains:**
- H1N1
- H3N2
- H7N3

**Parasites:**
- Plasmodium Malariae

**Controls:**
- PHIX174 (bacteriophage control)

### 4. Data Processing Tools

#### Python Integration Script (`Integration for PHIX174/`)
For data provided as derivative curves (dF/dT):
```python
# Integrates derivative to recover original fluorescence
python python_integration_code.py
```

Input: CSV with Temperature and dF/dT columns  
Output: CSV with Temperature, dF/dT, and integrated F columns

#### R Validation Scripts (`Quality Check For References/`)
For validating reference curves using DECIPHER:
```r
# Simulates melting curves from DNA sequences
source("meltDNA for PHIX174 Simulated Curves.R")
```

## 📝 Workflow Example

### Complete Analysis Pipeline

1. **Start with raw qPCR data**
   ```
   Temperature(°C), Fluorescence(RFU)
   70.0, 45000
   70.5, 44800
   ...
   ```

2. **Normalize using melt-normalizer.html**
   - Upload CSV → Auto-detect columns → Normalize → Download

3. **Load into tuner application**
   - Open DNA_Melting - Reference_vs_Simulation_Tuner.html
   - Upload normalized CSV or select reference strain
   - Choose simulation algorithm

4. **Optimize parameters**
   - Adjust Na⁺, Mg²⁺ concentrations to match your buffer
   - Tune cooperativity and algorithm-specific parameters
   - Observe real-time curve updates

5. **Evaluate fit**
   - Check RMSE (lower is better, < 0.05 is excellent)
   - Check R² (closer to 1.0 is better)
   - Visual inspection of overlay

6. **Validate (optional)**
   - Run R scripts to compare with DECIPHER predictions
   - Cross-reference with literature Tm values

## 🔬 Scientific Background

### Melting Curve Basics

DNA melting (thermal denaturation) is the process where double-stranded DNA (dsDNA) separates into single strands (ssDNA) as temperature increases.

**Biochemistry:**
- Intercalating dyes (SYBR Green, EvaGreen) bind to dsDNA and fluoresce
- As DNA melts, dye is released and fluorescence decreases
- qPCR instruments measure this fluorescence at each temperature
- The inflection point of the melting curve is the Tm (melting temperature)

**Factors affecting Tm:**
- **GC content**: Higher GC% → higher Tm (3 H-bonds vs 2 for AT)
- **Salt concentration**: Higher [Na⁺] → higher Tm (shields phosphate repulsion)
- **Mg²⁺**: Stabilizes dsDNA more than Na⁺
- **Sequence length**: Longer sequences → higher Tm
- **Sequence composition**: Nearest-neighbor effects matter

### Simulation Algorithms

This toolkit implements multiple models:

1. **Independent Model**
   - Treats each base pair as independent
   - Fast but ignores cooperative effects

2. **Thermodynamic Model (SantaLucia)**
   - Uses nearest-neighbor thermodynamics
   - Accounts for stacking interactions
   - Includes salt corrections (Owczarzy 2008)

3. **Polymer Model**
   - Statistical mechanics approach
   - Models DNA as a polymer chain
   - Captures long-range cooperativity

4. **Simple Sigmoid**
   - Empirical sigmoidal function
   - Good for quick approximations

## 📂 CSV Format Requirements

### For Normalization Tool
```csv
Temperature,Fluorescence
70.0,45000
70.5,44800
71.0,44500
...
```

### For Tuner Application (Normalized)
```csv
Temperature,fraction_melted
70.0,0.05
70.5,0.08
71.0,0.12
...
```

**Important:**
- Headers must be present
- Temperature in °C
- Fraction_melted should be 0-1 range
- No missing values

## 🛠️ Technical Details

### JavaScript Libraries Used
- **meltingLib.js**: Core simulation engine
  - Implements 4 melting algorithms
  - Salt correction calculations
  - Thermodynamic parameter sets
  
- **meltDNA_ref_curves.js**: Reference data
  - Pre-normalized experimental curves
  - DNA sequences for each strain
  - Metadata and annotations

### Browser Compatibility
- Chrome/Edge: ✅ Full support
- Firefox: ✅ Full support
- Safari: ✅ Full support
- Mobile browsers: ⚠️ Limited (large screens recommended)

### Data Processing
- Client-side only (no server required)
- CSV parsing with automatic column detection
- Real-time curve rendering using HTML5 Canvas
- Efficient numerical computations

## 📚 References

### Key Publications
1. SantaLucia, J. (1998). "A unified view of polymer, dumbbell, and oligonucleotide DNA nearest-neighbor thermodynamics." *PNAS* 95:1460–1465
2. Owczarzy, R. et al. (2008). "Predicting stability of DNA duplexes in solutions containing magnesium and monovalent cations." *Biochemistry* 47:5336–5353

### DECIPHER Package (R)
- Wright, E.S. (2016). "Using DECIPHER v2.0 to Analyze Big Biological Sequence Data in R." *The R Journal* 8:352-359

## 🤝 Usage Guidelines

### For Researchers
- Use normalized data for cross-experiment comparisons
- Document your buffer conditions (Na⁺, Mg²⁺ concentrations)
- Run multiple replicates and average curves
- Validate simulations against known controls (e.g., PHIX174)

### For Developers
- All tools are standalone HTML files (no build process)
- JavaScript libraries are self-contained
- Easy to modify and extend
- Can be hosted on any web server or used locally

## �� Troubleshooting

### Common Issues

**Q: Normalization tool says "Column not found"**  
A: Ensure your CSV has clear headers (e.g., "Temperature", "Fluorescence"). The tool looks for numeric columns.

**Q: Tuner shows poor fit (high RMSE)**  
A: Check that:
- Salt concentrations match your experimental buffer
- Reference sequence is correct
- Data is properly normalized
- Temperature range overlaps sufficiently

**Q: Curves look inverted**  
A: Some instruments output -dF/dT (negative derivative). Check your data source and invert if needed.

**Q: JavaScript errors in console**  
A: Ensure you're using a modern browser. Try disabling browser extensions that might interfere.

## 📄 License

This project is for research and educational use. Please cite appropriately if used in publications.

## 👤 Author

Bob Horton Final Project  
*DNA Melting Curve Analysis Toolkit*

## 🔗 Additional Resources

- **CSVs_for_Tuner_app/**: Contains example datasets for testing
  - RAW CSV: Original qPCR instrument outputs
  - NORMALIZED CSV: Ready-to-use processed data
  
- **Integration for PHIX174/**: Special processing for PHIX174 control
  - Use when data is in derivative form (dF/dT)
  - Python script handles integration automatically

- **Quality Check For References/**: Validation workflows
  - Compare your references with DECIPHER simulations
  - Overlay multiple strains for visual inspection

## 💡 Tips for Best Results

1. **Always normalize raw data first** - Don't skip this step
2. **Use appropriate salt concentrations** - Match your actual buffer
3. **Start with known controls** - Validate with PHIX174 or other standards
4. **Check temperature range** - Ensure sufficient baseline (before/after melt)
5. **Replicate experiments** - Average multiple runs for robust references
6. **Document everything** - Record experimental conditions, buffer composition, instrument settings

---

**For questions or issues, please refer to the HTML documentation files included in this repository.**
