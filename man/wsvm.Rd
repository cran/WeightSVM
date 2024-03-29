\name{wsvm}
\alias{wsvm}
\alias{wsvm.default}
\alias{wsvm.formula}
\alias{summary.wsvm}
\alias{print.summary.wsvm}
\alias{coef.wsvm}
\alias{print.wsvm}
\title{Subject Weighted Support Vector Machines}
\description{
\code{wsvm} is used to train a subject weighted support vector machine. It can be used to carry out general regression and classification (of nu and epsilon-type), as
well as density-estimation. A formula interface is provided.
}
\usage{
\method{wsvm}{formula}(formula, weight, data = NULL, ..., subset, na.action =
na.omit, scale = TRUE)
\method{wsvm}{default}(x, y = NULL, weight, scale = TRUE, type = NULL, kernel =
"radial", degree = 3, gamma = if (is.vector(x)) 1 else 1 / ncol(x),
coef0 = 0, cost = 1, nu = 0.5,
class.weights = NULL, cachesize = 100, tolerance = 0.001, epsilon = 0.1,
shrinking = TRUE, cross = 0, probability = FALSE, fitted = TRUE,
..., subset, na.action = na.omit)
}
\arguments{
  \item{formula}{a symbolic description of the model to be fit.}
  \item{data}{an optional data frame containing the variables in the model.
          By default the variables are taken from the environment which
          \sQuote{wsvm} is called from.}
  \item{x}{a data matrix, a vector, or a sparse '\emph{design} matrix' (object of class
    \code{\link[Matrix]{Matrix}} provided by the \pkg{Matrix} package,
    or of class \code{\link[SparseM]{matrix.csr}}
    provided by the \pkg{SparseM} package, or of class
    \code{\link[slam]{simple_triplet_matrix}} provided by the \pkg{slam}
    package). Or a kernel matrix of class \code{\link[kernlab]{kernelMatrix}} by the \pkg{kernlab} package.}
  \item{y}{a response vector with one label for each row/component of
    \code{x}. Can be either a factor (for classification tasks)
    or a numeric vector (for regression).}
  \item{weight}{the weight of each subject. It should be in the same length of \code{y}.}
  \item{scale}{A logical vector indicating the variables to be
    scaled. If \code{scale} is of length 1, the value is recycled as
    many times as needed.
    By default, data are scaled internally (both \code{x} and \code{y}
    variables) to zero mean and unit variance. The center and scale
    values are returned and used for later predictions. \emph{If x is a design matrix which contains dummy variables, please make these variable NOT scaled.}}
  \item{type}{\code{wsvm} can be used as a classification
    machine, as a regression machine, or for novelty detection.
    Depending of whether \code{y} is
    a factor or not, the default setting for \code{type} is \code{C-classification} or \code{eps-regression}, respectively, but may be overwritten by setting an explicit value.\cr
    Valid options are:
    \itemize{
      \item \code{C-classification}
      \item \code{nu-classification}
      \item \code{one-classification} (for novelty detection)
      \item \code{eps-regression}
      \item \code{nu-regression}
    }
  }
  \item{kernel}{the kernel used in training and predicting. You
    might consider changing some of the following parameters, depending
    on the kernel type.\cr
    \describe{
      \item{linear:}{\eqn{u'v}{u'*v}}
      \item{polynomial:}{\eqn{(\gamma u'v + coef0)^{degree}}{(gamma*u'*v + coef0)^degree}}
      \item{radial basis:}{\eqn{e^(-\gamma |u-v|^2)}{exp(-gamma*|u-v|^2)}}
      \item{sigmoid:}{\eqn{tanh(\gamma u'v + coef0)}{tanh(gamma*u'*v + coef0)}}
      \item{precomputed:}{x is a precomputed kernel matrix that contains NO missing values. \code{scale} will not work. Cannot use \code{subset} and \code{na.action} with this kernel. }
      }
    }
  \item{degree}{parameter needed for kernel of type \code{polynomial} (default: 3)}
  \item{gamma}{parameter needed for all kernels except \code{linear}
    (default: 1/(data dimension))}
  \item{coef0}{parameter needed for kernels of type \code{polynomial}
    and \code{sigmoid} (default: 0)}
  \item{cost}{cost of constraints violation (default: 1)---it is the
    \sQuote{C}-constant of the regularization term in the Lagrange formulation.}
  \item{nu}{parameter needed for \code{nu-classification},
    \code{nu-regression}, and \code{one-classification}}
  \item{class.weights}{a named vector of weights for the different
    classes, used for asymmetric class sizes. Not all factor levels have
    to be supplied (default weight: 1). All components have to be
    named. Specifying \code{"inverse"} will choose the weights \emph{inversely}
    proportional to the class distribution.}
  \item{cachesize}{cache memory in MB (default 100)}
  \item{tolerance}{tolerance of termination criterion (default: 0.001)}
  \item{epsilon}{epsilon in the insensitive-loss function (default: 0.1)}
  \item{shrinking}{option whether to use the shrinking-heuristics
    (default: \code{TRUE})}
  \item{cross}{if a integer value k>0 is specified, a k-fold cross
    validation on the training data is performed to assess the quality
    of the model: the accuracy rate for classification and the Mean
    Squared Error for regression. Note the result is not weighted. For weighted results,
    use \code{tune_wsvm} fucntion.}
  \item{fitted}{logical indicating whether the fitted values should be computed
    and included in the model or not (default: \code{TRUE})}
  \item{probability}{logical indicating whether the model should
    allow for probability predictions.}
  \item{\dots}{additional parameters for the low level fitting function
    \code{wsvm.default}}
  \item{subset}{An index vector specifying the cases to be used in the
          training sample.  (NOTE: If given, this argument must be
          named.)}
  \item{na.action}{A function to specify the action to be taken if \code{NA}s are
          found. The default action is \code{na.omit}, which leads to rejection of cases
          with missing values on any required variable. An alternative
	  is \code{na.fail}, which causes an error if \code{NA} cases
	  are found. (NOTE: If given, this argument must be named.)}
}

\value{
  An object of class \code{"wsvm"} containing the fitted model, including:
  \item{SV}{The resulting support vectors (possibly scaled).}
  \item{index}{The index of the resulting support vectors in the data
    matrix. Note that this index refers to the preprocessed data (after
    the possible effect of \code{na.omit} and \code{subset})}
  \item{coefs}{The corresponding coefficients times the training labels.}
  \item{rho}{The negative intercept.}
  \item{sigma}{In case of a probabilistic regression model, the scale
    parameter of the hypothesized (zero-mean) laplace distribution estimated by
    maximum likelihood.}
  \item{probA, probB}{numeric vectors of length k(k-1)/2, k number of
    classes, containing the parameters of the logistic distributions fitted to
    the decision values of the binary classifiers (1 / (1 + exp(a x + b))).}
}
\details{
  The original \code{libsvm} does not support subject/instance weighted svm. From the 'LIBSVM Tools' \url{https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances}, we are able to use a modified version of \code{libsvm} to support subject weights.

  For multiclass-classification with k levels, k>2, \code{libsvm} uses the
  \sQuote{one-against-one}-approach, in which k(k-1)/2 binary classifiers are
  trained; the appropriate class is found by a voting scheme.

  \code{libsvm} internally uses a sparse data representation, which is
  also high-level supported by the package \pkg{SparseM}.

  If the predictor variables include factors, the formula interface must be used to get a
  correct model matrix or make x a design matrix.

  When using the formula interface and \code{na.action} is \code{na.omit}, we delete any subjects with missing values on x, y (if exists) or weight in the training and predicting procedure (when \code{fitted = TRUE}). When using the x, y interface and \code{na.action} is \code{na.omit}, we delete any subjects with missing values on x, y (if exists) or weight in the training procedure, and retain the subjects with missing values only on weight in the predicting procedure (when \code{fitted = TRUE}).

  \code{plot.wsvm} allows a simple graphical
  visualization of classification models.

  The probability model for classification fits a logistic distribution
  using maximum likelihood to the decision values of all binary
  classifiers, and computes the a-posteriori class probabilities for the
  multi-class problem using quadratic optimization. The probabilistic
  regression model assumes (zero-mean) laplace-distributed errors for the
  predictions, and estimates the scale parameter using maximum
  likelihood.

  For linear kernel, the coefficients of the regression/decision hyperplane
  can be extracted using the \code{coef} method (see examples).
}
\note{
Data are scaled internally, usually yielding better results.

Parameters of SVM-models usually \emph{must} be tuned to yield sensible results!
}
\references{
  \itemize{
    \item
      Chang, Chih-Chung and Lin, Chih-Jen:\cr
      \emph{LIBSVM: a library for Support Vector Machines}\cr
      \url{https://www.csie.ntu.edu.tw/~cjlin/libsvm/}

    \item Ming-Wei Chang, Hsuan-Tien Lin, Ming-Hen Tsai, Chia-Hua Ho and Hsiang-Fu Yu\cr
     \emph{Weights for data instances}\cr
     \url{https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/#weights_for_data_instances}

     \item
      Exact formulations of models, algorithms, etc. can be found in the
      document:\cr
      Chang, Chih-Chung and Lin, Chih-Jen:\cr
      \emph{LIBSVM: a library for Support Vector Machines}\cr
      \url{https://www.csie.ntu.edu.tw/~cjlin/papers/libsvm.ps.gz}

      \item
      More implementation details and speed benchmarks can be found on:
      Rong-En Fan and Pai-Hsune Chen and Chih-Jen Lin:\cr
      \emph{Working Set Selection Using the Second Order Information for Training SVM}\cr
      \url{https://www.csie.ntu.edu.tw/~cjlin/papers/quadworkset.pdf}

  }
}
\author{
  David Meyer (based on C/C++-code by Chih-Chung Chang and Chih-Jen Lin)\cr
  Modified by Tianchen Xu \email{tx2155@columbia.edu}
}
\seealso{
  \code{\link{predict.wsvm}},
  \code{\link{plot.wsvm}},
  \code{\link{tune_wsvm}},
  \code{\link[SparseM]{matrix.csr}} (in package \pkg{SparseM})
}
\examples{
## check what is loaded
dllpath <- getLoadedDLLs()
getDLLRegisteredRoutines(dllpath$WeightSVM[[2]])

## load dataset
data(iris)

## classification mode
# default with factor response:
model1 <- wsvm(Species ~ ., weight = rep(1,150), data = iris) # same weights
model2 <- wsvm(x = iris[,1:4], y = iris[,5],
              weight = c(rep(0.08, 50),rep(1,100))) # less weights to setosa
# alternatively the traditional interface:
x <- subset(iris, select = -Species)
y <- iris$Species
model3 <- wsvm(x, y, weight = rep(10,150)) # similar to model 1,
                               # but larger weights for all subjects

# These models provide error/warning info
try(wsvm(x, y)) # no weight
try(wsvm(x, y, weight = rep(10,100))) # wrong length
try(wsvm(x, y, weight = c(Inf, rep(1,149)))) # contains inf weight

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
     pch = c("o","+")[1:150 \%in\% model1$index + 1]) # model 1
plot(cmdscale(dist(iris[,-5])),
     col = as.integer(iris[,5]),
     pch = c("o","+")[1:150 \%in\% model2$index + 1])
  # In model 2, less support vectors are based on setosa


## try regression mode on two dimensions
# create data
x <- seq(0.1, 5, by = 0.05)
y <- log(x) + rnorm(x, sd = 0.2)

# estimate model and predict input values
model1 <- wsvm(x, y, weight = rep(1,99))
model2 <- wsvm(x, y, weight = seq(99,1,length.out = 99)) # decreasing weights
# library(kernlab)
# model3 <- wsvm(kernlab::kernelMatrix(kernlab::rbfdot(sigma = 1), x), y,
#      weight = rep(1,99), kernel = 'precomputed') # try user defined kernel

# visualize
plot(x, y)
lines(x, log(x), col = 2)
points(x, fitted(model1), col = 4)
points(x, fitted(model2), col = 3) # better fit for the first few points
# points(x, fitted(model3), col = 5) # similar to model 1 with user defined kernel

## density-estimation
# create 2-dim. normal with rho=0:
X <- data.frame(a = rnorm(1000), b = rnorm(1000))
attach(X)

# formula interface:
model <- wsvm(~ a + b, gamma = 0.1, weight = c(seq(5000,1,length.out = 500),1:500))

# test:
newdata <- data.frame(a = c(0, 4), b = c(0, 4))

# visualize:
plot(X, col = 1:1000 \%in\% model$index + 1, xlim = c(-5,5), ylim=c(-5,5))
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
               data = iris2, kernel = "linear",
               weight = c(rep(0.08, 50),rep(1,100))) # less weights to setosa

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
}

\keyword{neural}
\keyword{nonlinear}
\keyword{classif}









