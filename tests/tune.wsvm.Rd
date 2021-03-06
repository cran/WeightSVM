\name{tune.wsvm}
\alias{tune.wsvm}
\alias{best.wsvm}
\title{Convenience Tuning Wrapper Functions}
\description{
  Convenience tuning wrapper functions, using \code{tune_wsvm}.

  \bold{This function is NOT maintained. Do not use it.}
}
\usage{
tune.wsvm(x, y = NULL, weight, data = NULL, degree = NULL, gamma = NULL, coef0 = NULL,
         cost = NULL, nu = NULL, class.weights = NULL, epsilon = NULL, ...)
best.wsvm(x, tunecontrol = tune.control(), ...)
}
\arguments{
  \item{formula, x, y, data}{formula and data arguments of function to be tuned.}
  \item{weight}{subject weight.}
  \item{predict.func}{predicting function.}
  \item{na.action}{function handling missingness.}
  \item{minsplit, minbucket, cp, maxcompete,
        maxsurrogate, usesurrogate, xval,
        surrogatestyle, maxdepth}{\code{rpart} parameters.}
  \item{degree, gamma, coef0, cost, nu, class.weights, epsilon}{\code{wsvm}
    parameters.}
  \item{k, l}{\code{knn} parameters.}
  \item{mtry, nodesize, ntree}{\code{randomForest} parameters.}
  \item{size, decay, trace}{parameters passed to
    \code{nnet}.}
  \item{tunecontrol}{object of class \code{"tune.control"} containing
    tuning parameters.}
  \item{\dots}{Further parameters passed to \code{tune_wsvm}.}
}

\value{
  \code{tune.wsvm} returns a tuning object including the best parameter set obtained
  by optimizing over the specified parameter vectors. \code{best.wsvm()}
  directly returns the best model, i.e. the fit of a new model using the
  optimal parameters found by \code{tune.wsvm}.
}
\details{For examples, see the help page of \code{tune_wsvm()}.}

\author{
  David Meyer \email{David.Meyer@R-project.org}\cr
    Modified by Tianchen Xu \email{tx2155@columbia.edu}
}
\seealso{\code{\link{tune_wsvm}}}

\keyword{models}
