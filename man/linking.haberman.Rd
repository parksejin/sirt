\name{linking.haberman}
\alias{linking.haberman}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Linking in the 2PL/Generalized Partial Credit Model
}
\description{
This function does the linking of serval studies which are calibrated
using the 2PL or the generalized item response model according to
Haberman (2009). This method is a generalization of log-mean-mean
linking from to to several studies.
}
\usage{
linking.haberman(itempars, personpars, conv = 1e-05, maxiter = 1000, 
    progress = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{itempars}{
A data frame with four or five columns. The first four columns contain
in the order: study name, item name, \eqn{a} parameter, \eqn{b} parameter.
The fifth column is an optional weight for every item and every study.
}
\item{personpars}{A list with vectors (e.g. EAPs or WLEs) or data frames
	(e.g. plausible values) containing person parameters which
	should be transformed.
If a data frame in each list entry has \code{se} or \code{SE}
(standard error) in a column name, then the corresponding
column is only multiplied by \eqn{A_t}.
If a column is labeled as \code{pid} (person ID),
then it is left untransformed.
}
\item{conv}{
Convergence criterion.
}
  \item{maxiter}{
Maximum number of iterations.
}
  \item{progress}{
An optional logical indicating whether computational progress
should be displayed.
}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DETAILS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



\details{
For \eqn{t=1,\ldots,T} studies, item difficulties \eqn{b_{it}} and
item slopes \eqn{a_{it}} are available. For dichotomous responses, these
parameters are defined by the 2PL response equation
\deqn{ logit P(X_{pi}=1| \theta_p ) = a_i ( \theta_p - b_i ) }
while for polytomous responses the generalized partial credit model holds
\deqn{ log \frac{P(X_{pi}=k| \theta_p )}{P(X_{pi}=k-1| \theta_p )}
= a_i ( \theta_p - b_i + d_{ik} ) }

The parameters \eqn{ \{ a_{it} , b_{it} \}} of all items and studies are
linearly transformed using equations \eqn{a_{it} \approx a_i / A_t} and
\eqn{b_{it} \cdot A_t \approx B_t + b_i}. For identification reasons
we define \eqn{A_1=1} and \eqn{B_1} = 0.

The optimization function (which is a least squares criterion;
see Haberman 2009) seeks the transformation parameters \eqn{A_t} and 
\eqn{B_t} with an alternating least squares 
method. Note that every item \eqn{i} and every study \eqn{t} can
be weighted (specified in the fifth column of \code{itempars}).

Effect sizes of invariance are calculated as R-squared measures
of explained item slopes and intercepts after linking
in comparison to item parameters across groups
(Asparouhov & Muthen, 2014).
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\value{
A list with following entries
  \item{transf.pars}{Data frame with transformation parameters
\eqn{A_t} and \eqn{B_t}
  }
%  \item{transf.itempars}{Data frame with linear transformation functions
%  for item parameters}
  \item{transf.personpars}{Data frame with linear transformation functions
  for person parameters}  
  \item{joint.itempars}{Estimated joint item parameters \eqn{a_i} and \eqn{b_i}
  	}
  \item{a.trans}{Transformed \eqn{a_{it}} parameters}
  \item{b.trans}{Transformed \eqn{b_{it}} parameters}
  \item{a.orig}{Original \eqn{a_{it}} parameters}
  \item{b.orig}{Original \eqn{b_{it}} parameters} 
  \item{personpars}{Tranformed person parameters}
  \item{es.invariance}{Effect size measures of invariance,
  	  separately for item slopes and intercepts.
  	  In the rows, \eqn{R^2} and \eqn{\sqrt{1-R^2}}
          are displayed.}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REFERENCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\references{
Asparouhov, T., & Muthen, B. (2014).
Multiple-group factor analysis alignment.
\emph{Structural Equation Modeling}, \bold{21}, 1-14.
	
Haberman, S. J. (2009). \emph{Linking parameter estimates derived
from an item response model through separate calibrations}. 
ETS Research Report ETS RR-09-40. Princeton, ETS.
}

\author{
Alexander Robitzsch
}


%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
See the \pkg{plink} package for a wide diversity of linking methods.

Mean-mean linking, Stocking-Lord and Haebara linking in the generalized
logistic item response model can be conducted with 
\code{\link{equating.rasch}}.

For more general linking functions than the Haberman method
see \code{\link{invariance.alignment}}.
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXAMPLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\examples{
#############################################################################
# EXAMPLE 1: Item parameters data.pars1.rasch and data.pars1.2pl
#############################################################################

# Model 1: Linking three studies calibrated by the Rasch model
data(data.pars1.rasch)
mod1 <- linking.haberman( itempars=data.pars1.rasch )

# Model 1b: Linking these studies but weigh these studies by
#     proportion weights 3 : 0.5 : 1  (see below).
#     All weights are the same for each item but they could also
#     be item specific.
itempars <- data.pars1.rasch
itempars$wgt <- 1
itempars[ itempars$study == "study1","wgt"] <- 3
itempars[ itempars$study == "study2","wgt"] <- .5
mod1b <- linking.haberman( itempars=itempars )

# Model 2: Linking three studies calibrated by the 2PL model
data(data.pars1.2pl)
mod2 <- linking.haberman( itempars=data.pars1.2pl )

\dontrun{
#############################################################################
# EXAMPLE 2: Linking longitudinal data
#############################################################################
data(data.long)

#******
# Model 1: Scaling with the 1PL model

# scaling at T1
dat1 <- data.long[ , grep("T1" , colnames(data.long) ) ]
resT1 <- rasch.mml2( dat1 )
itempartable1 <- data.frame( "study"="T1" , resT1$item[ , c("item" , "a" , "b" ) ] )
# scaling at T2
dat2 <- data.long[ , grep("T2" , colnames(data.long) ) ]
resT2 <- rasch.mml2( dat2 )
summary(resT2)
itempartable2 <- data.frame( "study"="T2" , resT2$item[ , c("item" , "a" , "b" ) ] )
itempartable <- rbind( itempartable1 , itempartable2 )
itempartable[,2] <- substring( itempartable[,2] , 1, 2 )
# estimate linking parameters
mod1 <- linking.haberman( itempars= itempartable )

#******
# Model 2: Scaling with the 2PL model

# scaling at T1
dat1 <- data.long[ , grep("T1" , colnames(data.long) ) ]
resT1 <- rasch.mml2( dat1 , est.a=1:6)
itempartable1 <- data.frame( "study"="T1" , resT1$item[ , c("item" , "a" , "b" ) ] )

# scaling at T2
dat2 <- data.long[ , grep("T2" , colnames(data.long) ) ]
resT2 <- rasch.mml2( dat2 , est.a=1:6)
summary(resT2)
itempartable2 <- data.frame( "study"="T2" , resT2$item[ , c("item" , "a" , "b" ) ] )
itempartable <- rbind( itempartable1 , itempartable2 )
itempartable[,2] <- substring( itempartable[,2] , 1, 2 )
# estimate linking parameters
mod2 <- linking.haberman( itempars= itempartable )

#############################################################################
# SIMULATED EXAMPLE 3: 2 Studies - 1PL and 2PL linking 
#############################################################################
set.seed(789)
I <- 20		# number of items
N <- 2000       # number of persons
# define item parameters
b <- seq( -1.5 , 1.5 , length=I )
# simulate data
dat1 <- sim.raschtype( rnorm( N , mean=0,sd=1 ) , b=b )
dat2 <- sim.raschtype( rnorm( N , mean=0.5,sd=1.50 ) , b=b )

#*** Model 1: 1PL
# 1PL Study 1
mod1 <- rasch.mml2( dat1 , est.a= rep(1,I) )
summary(mod1)
# 1PL Study 2
mod2 <- rasch.mml2( dat2 , est.a= rep(1,I) )
summary(mod2)

# collect item parameters
dfr1 <- data.frame( "study1" , mod1$item$item , mod1$item$a , mod1$item$b )
dfr2 <- data.frame( "study2" , mod2$item$item , mod2$item$a , mod2$item$b )
colnames(dfr2) <- colnames(dfr1) <- c("study" , "item" , "a" , "b" )
itempars <- rbind( dfr1 , dfr2 )

# Haberman linking
linkhab1 <- linking.haberman(itempars=itempars)
  ## Transformation parameters (Haberman linking)
  ##    study    At     Bt
  ## 1 study1 1.000  0.000
  ## 2 study2 1.465 -0.512
  ## 
  ## Linear transformation for item parameters a and b
  ##    study   A_a   A_b    B_b
  ## 1 study1 1.000 1.000  0.000
  ## 2 study2 0.682 1.465 -0.512
  ## 
  ## Linear transformation for person parameters theta
  ##    study A_theta B_theta
  ## 1 study1   1.000   0.000
  ## 2 study2   1.465   0.512
  ## 
  ## R-Squared Measures of Invariance
  ##        slopes intercepts
  ## R2          1     0.9979
  ## sqrtU2      0     0.0456

#*** Model 2: 2PL
# 2PL Study 1
mod1 <- rasch.mml2( dat1 , est.a= 1:I )
summary(mod1)
# 2PL Study 2
mod2 <- rasch.mml2( dat2 , est.a= 1:I )
summary(mod2)

# collect item parameters
dfr1 <- data.frame( "study1" , mod1$item$item , mod1$item$a , mod1$item$b )
dfr2 <- data.frame( "study2" , mod2$item$item , mod2$item$a , mod2$item$b )
colnames(dfr2) <- colnames(dfr1) <- c("study" , "item" , "a" , "b" )
itempars <- rbind( dfr1 , dfr2 )

# Haberman linking
linkhab2 <- linking.haberman(itempars=itempars)
  ## Transformation parameters (Haberman linking)
  ##    study    At     Bt
  ## 1 study1 1.000  0.000
  ## 2 study2 1.468 -0.515
  ## 
  ## Linear transformation for item parameters a and b
  ##    study   A_a   A_b    B_b
  ## 1 study1 1.000 1.000  0.000
  ## 2 study2 0.681 1.468 -0.515
  ## 
  ## Linear transformation for person parameters theta
  ##    study A_theta B_theta
  ## 1 study1   1.000   0.000
  ## 2 study2   1.468   0.515
  ## 
  ## R-Squared Measures of Invariance
  ##        slopes intercepts
  ## R2     0.9984     0.9980
  ## sqrtU2 0.0397     0.0443

#############################################################################
# SIMULATED EXAMPLE 4: 3 Studies - 1PL and 2PL linking 
#############################################################################
set.seed(789)
I <- 20         # number of items
N <- 1500       # number of persons
# define item parameters
b <- seq( -1.5 , 1.5 , length=I )
# simulate data
dat1 <- sim.raschtype( rnorm( N , mean=0,sd=1 ) , b=b )
dat2 <- sim.raschtype( rnorm( N , mean=0.5,sd=1.50 ) , b=b )
dat3 <- sim.raschtype( rnorm( N , mean=-.2,sd=.8 ) , b=b )
# set some items to non-administered
dat3 <- dat3[ , -c(1,4) ]
dat2 <- dat2[ , -c(1,2,3) ] 

#*** Model 1: 1PL in sirt
# 1PL Study 1
mod1 <- rasch.mml2( dat1 , est.a= rep(1,ncol(dat1)) )
summary(mod1)
# 1PL Study 2
mod2 <- rasch.mml2( dat2 , est.a= rep(1,ncol(dat2)) )
summary(mod2)
# 1PL Study 3
mod3 <- rasch.mml2( dat3 , est.a= rep(1,ncol(dat3)) )
summary(mod3)

# collect item parameters
dfr1 <- data.frame( "study1" , mod1$item$item , mod1$item$a , mod1$item$b )
dfr2 <- data.frame( "study2" , mod2$item$item , mod2$item$a , mod2$item$b )
dfr3 <- data.frame( "study3" , mod3$item$item , mod3$item$a , mod3$item$b )
colnames(dfr3) <- colnames(dfr2) <- colnames(dfr1) <- c("study" , "item" , "a" , "b" )
itempars <- rbind( dfr1 , dfr2 , dfr3 )

# use person parameters
personpars <- list( mod1$person[ , c("EAP","SE.EAP") ] , mod2$person[ , c("EAP","SE.EAP") ] ,
    mod3$person[ , c("EAP","SE.EAP") ] )

# Haberman linking
linkhab1 <- linking.haberman(itempars=itempars , personpars=personpars)
# compare item parameters
round( cbind( linkhab1$joint.itempars[,-1], linkhab1$b.trans )[1:5,] , 3 )
  ##            aj     bj study1 study2 study3
  ##   I0001 0.998 -1.427 -1.427     NA     NA
  ##   I0002 0.998 -1.290 -1.324     NA -1.256
  ##   I0003 0.998 -1.140 -1.068     NA -1.212
  ##   I0004 0.998 -0.986 -1.003 -0.969     NA
  ##   I0005 0.998 -0.869 -0.809 -0.872 -0.926

# summary of person parameters of second study
round( psych::describe( linkhab1$personpars[[2]] ) , 2 )
  ##   var    n mean   sd median trimmed  mad   min  max range  skew kurtosis
  ## EAP      1 1500 0.45 1.36   0.41    0.47 1.52 -2.61 3.25  5.86 -0.08    -0.62
  ## SE.EAP   2 1500 0.57 0.09   0.53    0.56 0.04  0.49 0.84  0.35  1.47     1.56
  ##          se
  ## EAP    0.04
  ## SE.EAP 0.00

#*** Model 2: 2PL in TAM
library(TAM)
# 2PL Study 1
mod1 <- TAM::tam.mml.2pl( resp=dat1 , irtmodel="2PL" )
pvmod1 <- TAM::tam.pv(mod1, ntheta=300 , normal.approx=TRUE) # draw plausible values
summary(mod1)
# 2PL Study 2
mod2 <- TAM::tam.mml.2pl( resp=dat2 , irtmodel="2PL" )
pvmod2 <- TAM::tam.pv(mod2, ntheta=300 , normal.approx=TRUE)
summary(mod2)
# 2PL Study 3
mod3 <- TAM::tam.mml.2pl( resp=dat3 , irtmodel="2PL" )
pvmod3 <- TAM::tam.pv(mod3, ntheta=300 , normal.approx=TRUE)
summary(mod3)

# collect item parameters
#!!  Note that in TAM the parametrization is a*theta - b while linking.haberman
#!!  needs the parametrization a*(theta-b)
dfr1 <- data.frame( "study1" , mod1$item$item , mod1$B[,2,1] , mod1$xsi$xsi / mod1$B[,2,1] )
dfr2 <- data.frame( "study2" , mod2$item$item , mod2$B[,2,1] , mod2$xsi$xsi / mod2$B[,2,1] )
dfr3 <- data.frame( "study3" , mod3$item$item , mod3$B[,2,1] , mod3$xsi$xsi / mod3$B[,2,1] )
colnames(dfr3) <- colnames(dfr2) <- colnames(dfr1) <- c("study" , "item" , "a" , "b" )
itempars <- rbind( dfr1 , dfr2 , dfr3 )

# define list containing person parameters
personpars <- list(  pvmod1$pv[,-1] , pvmod2$pv[,-1] , pvmod3$pv[,-1] )

# Haberman linking
linkhab2 <- linking.haberman(itempars=itempars,personpars=personpars)
  ##   Linear transformation for person parameters theta
  ##      study A_theta B_theta
  ##   1 study1   1.000   0.000
  ##   2 study2   1.485   0.465
  ##   3 study3   0.786  -0.192

# extract transformed person parameters
personpars.trans <- linkhab2$personpars
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Linking}
\keyword{Equating}
