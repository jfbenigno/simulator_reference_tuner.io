# --- DECIPHER MeltDNA Full Workflow for phiX174 ---

# 1. Install necessary packages (run once)
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DECIPHER", force = TRUE)
BiocManager::install("Biostrings", force = TRUE)

# 2. Load libraries
library(DECIPHER, force = TRUE)
library(Biostrings)

# 3. Prepare your phiX174 sequence as one long string
mySeq <- ("gagttttatcgcttccatgacgcagaagttaacactttcggatatttctgatgagtcgaaaaattatcttgataaagcaggaattactactgcttgtttacgaattaaatcgaagtggactgctggcggaaaatgagaaaattcgacctatccttgcgcagctcgagaagctcttactttgcgacctttcgccatcaactaacgattctgtcaaaaactgacgcgttggatgaggagaagtggcttaatatgcttggcacgttcgtcaaggactggtttagatatgagtcacattttgttcatggtagagattctcttgttgacattttaaaagagcgtggattactatctgagtccgatgctgttcaaccactaataggtaagaaatcatgagtcaagttactgaacaatccgtacgtttccagaccgctttggcctctattaagctcattcaggcttctgccgttttggatttaaccgaagatgatttcgattttctgacgagtaacaaagtttggattgctactgaccgctctcgtgctcgtcgctgcgttgaggcttgcgtttatggtacgctggactttgtgggataccctcgctttcctgctcctgttgagtttattgctgccgtcattgcttatttatgttcatcccgtcaacattcaaacggcctgtctcatcatggaaggcgctgaatttacggaaaacattattaatggcgtcgagcgtccggttaaagccgctgaattgttcgcgtttaccttgcgtgtacgcgcaggaaacactgacgttcttactgacgcagaagaaaacgtgcgtcaaaaattacgtgcggaaggagtgatgtaatgtctaaaggtaaaaaacgttctggcgctcgccctggtcgtccgcagccgttgcgaggtactaaaggcaagcgtaaaggcgctcgtctttggtatgtaggtggtcaacaattttaattgcaggggcttcggccccttacttgaggataaattatgtctaatattcaaactggcgccgagcgtatgccgcatgacctttcccatcttggcttccttgctggtcagattggtcgtcttattaccatttcaactactccggttatcgctggcgactccttcgagatggacgccgttggcgctctccgtctttctccattgcgtcgtggccttgctattgactctactgtagacatttttactttttatgtccctcatcgtcacgtttatggtgaacagtggattaagttcatgaaggatggtgttaatgccactcctctcccgactgttaacactactggttatattgaccatgccgcttttcttggcacgattaaccctgataccaataaaatccctaagcatttgtttcagggttatttgaatatctataacaactattttaaagcgccgtggatgcctgaccgtaccgaggctaaccctaatgagcttaatcaagatgatgctcgttatggtttccgttgctgccatctcaaaacatttggactgctccgcttcctcctgagactgagctttctcgccaaatgacgacttctaccacatctattgacattatgggtctgcaagctgcttatgctaatttgctactgaccaagaacgtgattacttcatgcagcgttaccatgatgttatttcttcatttggaggtaaaacctcttatgacgctgacaaccgtcctttacttgtcatgcgctctaatctctgggcatctggctatgatgttgatggaactgaccaaacgtcgttaggccagttttctggtcgtgttcaacagacctataaacattctgtgccgcgtttctttgttcctgagcatggcactatgtttactcttgcgcttgttcgttttccgcctactgcgactaaagagatttcagtaccttaacgctaaaggtgctttgacttataccgatattgctggcgaccctgttttgtatggcaacttgccgccgcgtgaaatttctatgaaggatgttttccgttctggtgattcgtctaagaagtttaagattgctgagggtcagtggtatcgttatgcgccttcgtatgtttctcctgcttatcaccttcttgaaggcttcccat tcattcaggaaccgccttctggtgatttgcaagaacgcgtacttattcgccaccatgattatgaccagtgtttccagtccgttcagttgttgcagtggaatagtcaggttaaatttaatgtgaccgtttatcgcaatctgccgaccactcgcgattcaatcatgacttcgtgataaaagattgagtgtgaggttataacgccgaagcggtaaaaattttaatttttgccgctgaggggttgaccaagcgaagcgcggtaggttttctgcttaggagtttaatcatgtttcagacttttatttctcgccataattcaaactttttttctgataagctggttctcacttctgttactccagcttcttcggcacctgttttaa")  # (Paste full sequence here; no spaces, returns or numbers!)

# 4. Clean sequence (remove anything that's not A/C/G/T/N)
mySeq <- gsub("[^ACGTNacgtn]", "", mySeq)
dna_obj <- DNAString(mySeq)
dna <- DNAStringSet(dna_obj)

# 5. Specify temperature range for simulation
temps <- seq(69, 75, 0.1)  # Adjust range/step for your region of interest

# 6. Run melting curve simulation (fraction melted as function of temperature)
melt_curve <- MeltDNA(dna, type = "melt", temps = temps, ions = 0.0165)  # 15 mM NaCl + 1.5 mM citrate

# 7. Alternatively, run derivative curve for peak detection
deriv_curve <- MeltDNA(dna, type = "derivative", temps = temps, ions = 0.0165)

# 8. Plot raw melting curve
plot(
  temps,
  melt_curve,
  type = "l",
  col = "forestgreen",
  lwd = 2,
  xlab = "Temperature (°C)",
  ylab = expression(theta),
  main = expression(phi*X[174]*" MeltDNA Simulated Curve")
)
grid()

# 9. Plot derivative curve for peak/transition analysis
plot(
  temps,
  deriv_curve,
  type = "l",
  col = "blue",
  lwd = 2,
  xlab = "Temperature (°C)",
  ylab = "-d(Theta)/dT",
  main = expression(phi*X[174]*" MeltDNA Derivative Curve")
)
grid()

# 10. Export results to CSV for further analysis/overlay
write.csv(
  data.frame(Temperature = temps, Melt = melt_curve, Derivative = deriv_curve),
  "/Users/jaren/Desktop/BTEC 640/Bob Horton Project/DECIPHER_phiX174_melt_curve.csv",
  row.names = FALSE
)
a

