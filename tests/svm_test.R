# Model part --------------------------------------------------------------
## check what is loaded
# dllpath <- getLoadedDLLs()
# getDLLRegisteredRoutines(dllpath$WeightSVM[[2]])

## load dataset
require('WeightSVM')
data(iris)

## classification mode
# default with factor response:
model1 <- wsvm(Species ~ ., weight = rep(1,150), data = iris) # same weights
model2 <- wsvm(x = iris[,1:4], y = iris[,5], weight = c(rep(0.08, 50),rep(1,100))) # less weights to setosa
# alternatively the traditional interface:
x <- subset(iris, select = -Species)
y <- iris$Species
model3 <- wsvm(x, y, weight = rep(10,150)) # similar to model 1, but larger weights for all subjects

## weight length, weight is not null !!! weight range!! number of zeros !! Inf
# These models provide error/warning info
# wsvm(x, y) # no weight
# wsvm(x, y, weight = rep(10,100)) # wrong lengty
# wsvm(x, y, weight = c(Inf, rep(1,149))) # contains inf weight
# wsvm(x, y, weight = rep(0,150)) # all weights are zeros
# wsvm(x, y, weight = c(rep(0,25),rep(-1,25),rep(1,100))) # drop subjects with zero or nagetive weights

print(model1)
summary(model1)

# test with train data
pred <- predict(model1, iris[,1:4])
# (same as:)
pred <- fitted(model1)

# Check accuracy:
table(pred, y) # model 1, equal weights

# compute decision values and probabilities:
pred <- predict(model1, x, decision.values = TRUE)
attr(pred, "decision.values")[1:4,]

# visualize (classes by color, SV by crosses):
plot(cmdscale(dist(iris[,-5])),
     col = as.integer(iris[,5]),
     pch = c("o","+")[1:150 %in% model1$index + 1]) # model 1
plot(cmdscale(dist(iris[,-5])),
     col = as.integer(iris[,5]),
     pch = c("o","+")[1:150 %in% model2$index + 1]) # In model 2, less support vectors are based on setosa


## try regression mode on two dimensions
# create data
x <- seq(0.1, 5, by = 0.05)
y <- log(x) + rnorm(x, sd = 0.2)

# estimate model and predict input values
model1 <- wsvm(x, y, weight = rep(1,99))
model2 <- wsvm(x, y, weight = seq(99,1,length.out = 99)) # decreasing weights

# visualize
plot(x, y)
points(x, log(x), col = 2)
points(x, fitted(model1), col = 4)
points(x, fitted(model2), col = 3) # better fit for the first few points

## density-estimation
# create 2-dim. normal with rho=0:
X <- data.frame(a = rnorm(1000), b = rnorm(1000))
attach(X)

# formula interface:
model <- wsvm(~ a + b, gamma = 0.1, weight = c(seq(5000,1,length.out = 500),1:500))

# test:
newdata <- data.frame(a = c(0, 4), b = c(0, 4))

# visualize:
plot(X, col = 1:1000 %in% model$index + 1, xlim = c(-5,5), ylim=c(-5,5))
points(newdata, pch = "+", col = 2, cex = 5)

## class weights:
i2 <- iris
levels(i2$Species)[3] <- "versicolor"
summary(i2$Species)
wts <- 100 / table(i2$Species)
wts
m <- wsvm(Species ~ ., data = i2, class.weights = wts, weight=rep(1,150))

## extract coefficients for linear kernel

# a. regression
x <- 1:100
y <- x + rnorm(100)
m <- wsvm(y ~ x, scale = FALSE, kernel = "linear", weight = rep(1,100))
coef(m)
plot(y ~ x)
abline(m, col = "red")

# b. classification
# transform iris data to binary problem, and scale data
setosa <- as.factor(iris$Species == "setosa")
iris2 = scale(iris[,-5])

# fit binary C-classification model
model1 <- wsvm(setosa ~ Petal.Width + Petal.Length,
          data = iris2, kernel = "linear", weight = rep(1,150))
model2 <- wsvm(setosa ~ Petal.Width + Petal.Length,
               data = iris2, kernel = "linear", weight = c(rep(0.08, 50),rep(1,100))) # less weights to setosa

# plot data and separating hyperplane
plot(Petal.Length ~ Petal.Width, data = iris2, col = setosa)
(cf <- coef(model1))
abline(-cf[1]/cf[3], -cf[2]/cf[3], col = "red")
(cf2 <- coef(model2))
abline(-cf2[1]/cf2[3], -cf2[2]/cf2[3], col = "red", lty = 2)

# plot margin and mark support vectors
abline(-(cf[1] + 1)/cf[3], -cf[2]/cf[3], col = "blue")
abline(-(cf[1] - 1)/cf[3], -cf[2]/cf[3], col = "blue")
points(model1$SV, pch = 5, cex = 2)
abline(-(cf2[1] + 1)/cf2[3], -cf2[2]/cf2[3], col = "blue", lty = 2)
abline(-(cf2[1] - 1)/cf2[3], -cf2[2]/cf2[3], col = "blue", lty = 2)
points(model2$SV, pch = 6, cex = 2)


# Tuning ------------------------------------------------------------------
data(iris)

obj <- tune_wsvm(Species~., weight = c(rep(0.8, 50),rep(1,100)), data = iris, ranges = list(gamma = 2^(-1:10), cost = 2^(2:4)), tunecontrol = tune.control(sampling = "fix"))

# set.seed(11)
# obj <- tune_wsvm(Species~., weight = c(rep(1, 52),rep(0,98)), data = iris, use_zero_weight = TRUE, ranges = list(gamma = 2^(-1:1), cost = 2^(2:4)), tunecontrol = tune.control(sampling = "bootstrap"))

summary(obj)
plot(obj, transform.x = log2, transform.y = log2)
plot(obj, type = "perspective", theta = 120, phi = 45)


best.tune_wsvm(Species~.,weight = c(rep(0.08, 50),rep(1,100)), data = iris, ranges = list(gamma = 2^(-1:1), cost = 2^(2:4)), tunecontrol = tune.control(sampling = "fix"))

