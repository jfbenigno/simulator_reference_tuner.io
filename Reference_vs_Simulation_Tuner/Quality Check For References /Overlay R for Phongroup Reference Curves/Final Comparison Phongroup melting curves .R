# Install and load required packages if needed
install.packages("jpeg")
install.packages("readr")
library(jpeg)
library(readr)

# Set working directory
setwd("/Users/jaren/Desktop/BTEC 640/WEEK 6 Individual Report")

# Read plot image (ensure filename matches your image)
img <- readJPEG("Base.jpg")

# Perfectly matched axis: set the plot and image overlay to match y=0 to y=100
plot(1, type="n", xlim=c(79.5, 90), ylim=c(0, 100),
     xlab="Temperature (°C)", ylab="Normalized Fluorescence")

# Make sure the image fills exactly the plotting region 0 to 100 on y-axis
########rasterImage(img, 79.5, 0, 90, 100)
# --- Adjust image vertical scaling and position ---
y_scale  <- 1.10   # >1 stretches vertically; <1 compresses
y_offset <- +6    # move image up/down (positive moves up)

# Compute scaled coordinates
y_bottom <- 0 - (y_scale - 1) * 100 / 2 + y_offset
y_top    <- 100 + (y_scale - 1) * 100 / 2 + y_offset

# Redraw image with new vertical scale
rasterImage(img, 79.5, y_bottom, 90, y_top)

# Load curves using the exact file names you provided
curve_bronze     <- read_csv("FCV-TH:KP82 (Clinical Sample) Bronze.csv")
curve_neon       <- read_csv("FCV-TH:KP367 (Clinical Sample) NEON .csv")
curve_lightgray  <- read_csv("FCV-TH:KP181 (clinical Sample) light gray.csv")
curve_darkgreen  <- read_csv("FCV-TH:KP361. (Clinical Sample) DARK GREEN.csv")
curve_blue       <- read_csv("FCV-TH:KP313 (Clinicl Sample) Blue .csv")
curve_pink       <- read_csv("FCV-TH:KP106 (clinical sample) PINK.csv")
curve_darkbrown  <- read_csv("FCV-TH:KP80 Dark Brown.csv")
curve_darkgray   <- read_csv("FCV-TH:KP135 (clinical sample) Dark Gray .csv")

# Assign colors to match legend
curve_colors <- c("tan", "chartreuse", "gray80", "darkgreen",
                  "blue", "hotpink", "brown4", "gray50")

# List curves for ease
curve_list <- list(curve_bronze, curve_neon, curve_lightgray, curve_darkgreen,
                   curve_blue, curve_pink, curve_darkbrown, curve_darkgray)

# Overlay points and splines (using first two columns of each CSV)
for (i in seq_along(curve_list)) {
  dat <- curve_list[[i]]
  x <- dat[[1]]
  y <- dat[[2]]
  points(x, y, col=curve_colors[i], pch=16)
  spline_fit <- smooth.spline(x, y, spar=0.7)
  lines(spline_fit, col=curve_colors[i], lwd=2)
}






# Overlay new curves using same style
for (i in (length(curve_list)-7):length(curve_list)) {
  dat <- curve_list[[i]]
  x <- dat[[1]]
  y <- dat[[2]]
  points(x, y, col=curve_colors[i], pch=16)
  spline_fit <- smooth.spline(x, y, spar=0.7)
  lines(spline_fit, col=curve_colors[i], lwd=2)
}

# Optional: check y-value range coverage for all curves
for (i in seq_along(curve_list)) {
  dat <- curve_list[[i]]
  print(range(dat[[2]]))
}

