### NEWSVENDOR MODEL ###

# Import SCperf package
library(SCperf)
library(svDialogs)

link = 'cases/Newsvendor_case.xlsx'

import = readxl::read_xlsx(link,sheet = 1)
Newsvendor_D = import$Newsvendor_D[!is.na(import$Newsvendor_D)]
Newsvendor_sd = import$Newsvendor_sd[!is.na(import$Newsvendor_sd)]
Newsvendor_p = import$Newsvendor_p[!is.na(import$Newsvendor_p)]
Newsvendor_c = import$Newsvendor_c[!is.na(import$Newsvendor_c)]
Newsvendor_s = import$Newsvendor_s[!is.na(import$Newsvendor_s)]

# Get Newsboy Model Results 
Newsboy <- Newsboy(Newsvendor_D, Newsvendor_sd, Newsvendor_p, Newsvendor_c, Newsvendor_s)

Newsvendor_Q <- as.numeric(Newsboy[1])
print(paste("Optimal order-up-to quantity:", ceiling(Newsvendor_Q)))

Newsvendor_SS <- as.numeric(Newsboy[2])
print(paste("Safety stock:", ceiling(Newsvendor_SS)))

Newsvendor_ExpC <- as.numeric(Newsboy[3])
print(paste("Expected cost:", round(Newsvendor_ExpC, 2)))

Newsvendor_ExpP <- as.numeric(Newsboy[4])
print(paste("Expected profit:", round(Newsvendor_ExpP, 2)))

# Build Normal Distribution Plot
x <- seq(Newsvendor_D-(3.5*Newsvendor_sd), Newsvendor_D+(3.5*Newsvendor_sd), by = .1)
y <- dnorm(x, mean = Newsvendor_D, sd = Newsvendor_sd)
plot(x, y, 
     type = "l",
     lwd = 2,
     xlab = "Demand",
     ylab = "Probability Density", 
     main = "Newsvendor Model - Demand Distribution ",
     # sub = "Inventory Planning and Managing",
     xlim = c(Newsvendor_D-(3.5*Newsvendor_sd), Newsvendor_D+(3.5*Newsvendor_sd)))
abline(h = 0)


# Shade first half of the plot
x <- seq(Newsvendor_D-(3.5*Newsvendor_sd), Newsvendor_D, by = .1)
y <- dnorm(x, mean = Newsvendor_D, sd = Newsvendor_sd)
polygon(c(Newsvendor_D-(3.5*Newsvendor_sd), x, Newsvendor_D), c(0, y, 0), col = "light gray")


# Shade safety stock part of the plot
x <- seq(Newsvendor_D, Newsboy[1], by = .1)
y <- dnorm(x, mean = Newsvendor_D, sd = Newsvendor_sd)
polygon(c(Newsvendor_D, x, Newsboy[1]), c(0, y, 0), col = "light blue")

# Add text to the plot
ss <- as.numeric(pnorm(Newsboy[1], mean = Newsvendor_D ,sd = Newsvendor_sd) - 0.5)
text(Newsboy[1], 0, ceiling(Newsboy[1]), adj = c(0.5, 0.5))
text(Newsboy[1] - Newsboy[2], 0, paste(round(ss*100, 1), "%"), adj = c(-0.25, -10))
text(Newsboy[1] - Newsboy[2], 0, "50 %", adj = c(1.2, -10))
