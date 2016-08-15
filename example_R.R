### Instantaneous geometric rates via Generalized Linear Models
### Andrea Discacciati, Matteo Bottai

# R code to reproduce the example in the manuscript

library(haven)
library(survival)
library(rms)
library(Epi)
source("http://www.imm.ki.se/biostatistics/gr/links_igr.txt")

### chunk 1
kidney <- read_dta("http://www.imm.ki.se/biostatistics/data/kidney.dta")
kidney$survtime365 <- kidney$survtime / 365.24

kidney.split <- survSplit(Surv(survtime365, cens) ~ ., 
                          kidney, 
                          cut = seq(0, max(kidney$survtime365), 1/52))
kidney.split$risktime <- kidney.split$survtime365 - kidney.split$tstart
knots <- c(min(kidney.split$survtime365[kidney.split$cens == 1]),
           quantile(kidney.split$survtime365[kidney.split$cens == 1], c(.33, .66)),
           max(kidney.split$survtime365[kidney.split$cens == 1]))
###

### chunk 2
model1 <- glm(cens ~ rcs(survtime365, knots) + trt, data = kidney.split,
              family = poisson(link=log_igr(kidney.split$risktime)),
              start = c(-0.5, rep(0, 4)))
summary(model1)
round(ci.exp(model1)[5,], 3)
###

### chunk 3
newdata <- data.frame(survtime365 = rep(seq(0, 6.2, 0.1), 2), 
                      trt = rep(c(0,1), each = 63))
kidney.predict <- exp(predict(model1, newdata = newdata))

plot(newdata$survtime365[newdata$trt == 1], kidney.predict[newdata$trt == 1], 
     type = "l", log = "y", ylim = c(0.2, 0.75), lwd = 3, lty = "dashed",
     ylab = "Instantanoeus geometric rate (per year)",
     xlab = "Years from randomization", las = 1)
lines(newdata$survtime365[newdata$trt == 0], kidney.predict[newdata$trt == 0],
      lwd = 3)
legend(5, .7, c("MPA", "IFN"), cex = 1.5, lty=c("solid","dashed"), 
       lwd=c(3,3), bty ="n")
###

### chunk 4
model2 <- glm(cens ~ rcs(survtime365, knots)*trt, data = kidney.split,
              family = poisson(link=log_igr(kidney.split$risktime)),
              start = c(-0.5, rep(0, 7)))
summary(model2)

kidney.predict2 <- exp(predict(model2, newdata = newdata))

newdata2 <- cbind(newdata[newdata$trt==1,2], 
                  rcspline.eval(newdata[newdata$trt==1,1], knots, inclx = TRUE)*newdata[newdata$trt==1,2])
terms <- grep("trt", names(coef(model2)))
kidney.predict3 <- ci.lin(model2, subset = terms, ctr.mat = newdata2, Exp = T)

par(mar = c(5,5,2,5))
plot(newdata$survtime365[newdata$trt == 1], kidney.predict2[newdata$trt == 1], 
     type = "l", log = "y", ylim = c(0.10, 0.75), lwd = 3, lty = 5,
     ann = F, las = 1, axes = FALSE)
lines(newdata$survtime365[newdata$trt == 0], kidney.predict2[newdata$trt == 0],
      lwd = 3)
axis(side = 2, at = seq(0.25, 0.75, by=0.1), las = 1)
mtext(side = 2, "Instantanoeus geometric rate (per year)", line = 3, adj = 1)
axis(side = 1, at = seq(0, 6, by=1), las = 1)
mtext(side = 1, "Years since randomization", line = 2)
legend(5, .7, c("MPA", "IFN"), lty=c(1, 5), lwd=c(3,3), bty = "n", seg.len=5)
par(new = T)
plot(newdata$survtime365[newdata$trt == 1], kidney.predict3[,5],
     type = "l", log = "y", axes = F, xlab = NA, ylab = NA, lwd = 3, lty = 2,
     ylim = c(0.65, 2.5), yaxt = "n")
axis(side = 4, at = c(0.70, 0.84, 1), las = 2)
mtext(side = 4, line = 3, "Instantanoeus geometric rate ratio", adj = 0)
###

### chunk 5
Wald(model2, subset = grep(":trt", names(coef(model2))))
###

### chunk 6
model3 <- glm(cens ~ rcs(survtime365, knots) + wcc*trt, data = kidney.split,
              family = poisson(link=logit_igr(kidney.split$risktime)),
              start = c(-0.5, rep(0, 6)))
summary(model3)
###

### chunk 7
newdata3 <- cbind(rep(1, 35), seq(3, 20, by = 0.5))
terms <- grep("trt", names(coef(model3)))
kidney.predict4 <- ci.lin(model3, subset = terms, ctr.mat = newdata3, Exp = T)

matplot(newdata3[,2], kidney.predict4[,c(5,6,7)], type = "l", col = "black",
        lty = c(1,2,2), log = "y", lwd=c(3,3,3), yaxt = "n",
        ylab = "Instantaneous geometric odds ratio",
        xlab = "White cell count (x 10^9/l)")
axis(side = 2, at = c(.25, .5, 1, 2, 4, 8, 16), las = 2)
###

