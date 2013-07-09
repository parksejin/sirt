//  Code created: 2013-07-07 20:25:48


// includes from the plugin

#include <Rcpp.h>


#ifndef BEGIN_RCPP
#define BEGIN_RCPP
#endif

#ifndef END_RCPP
#define END_RCPP
#endif

using namespace Rcpp;


// user includes


// declarations
extern "C" {
SEXP MML2_RASCHTYPE_COUNTS( SEXP dat2, SEXP dat2resp, SEXP dat1, SEXP fqkyi, SEXP pik, SEXP fyiqk) ;
}

// definition

SEXP MML2_RASCHTYPE_COUNTS( SEXP dat2, SEXP dat2resp, SEXP dat1, SEXP fqkyi, SEXP pik, SEXP fyiqk ){
BEGIN_RCPP
  
     /////////////////////////////////////  
     // INPUT  
     Rcpp::NumericMatrix DAT2(dat2);  
     Rcpp::NumericMatrix DAT2RESP(dat2resp);  
     Rcpp::NumericVector DAT1(dat1) ;  
     Rcpp::NumericMatrix FQKYI(fqkyi) ;  
     Rcpp::NumericVector PIK (pik) ;   
     Rcpp::NumericMatrix FYIQK(fyiqk) ;  
       
     int N=DAT2.nrow();  
     int I=DAT2.ncol();  
     int TP=FQKYI.ncol();  
       
     //**********************************  
     // calculate total counts n.k  
     NumericVector NK (TP);  
     NK.fill(0);  
       
     for (int tt=0;tt<TP;++tt){      
         for (int nn=0;nn<N;++nn){  
     //        NK[tt] = NK[tt] + FQKYI(nn,tt)*DAT1[nn] ;   
               NK[tt] += FQKYI(nn,tt)*DAT1[nn] ;   
                         } // end nn  
                     }  // end tt  
       
     //**********************************  
     // calculate n.jk and r.jk  
     NumericMatrix NJK (I,TP) ;  
     NumericMatrix RJK (I,TP) ;  
     NJK.fill(0) ;                   
     RJK.fill(0) ;    
                       
     for (int ii=0;ii<I;++ii){  
     for (int tt=0;tt<TP;++tt){  
         for (int nn=0;nn<N;++nn){  
             if (DAT2RESP(nn,ii)>0){  
                 NJK(ii,tt) += DAT1[nn] * FQKYI(nn,tt) ;   
                 RJK(ii,tt) += DAT1[nn] * FQKYI(nn,tt) * DAT2(nn,ii) ;               
                             }       // end if ...  
             }           //     end nn  
         } // end tt  
     }    // end ii  
       
     //*****************  
     // calculate loglikelihood  
       
     double LL=0;  
       
     //        ll[gg] <- sum( dat1[group==gg,2] * log( rowSums( f.yi.qk[group==gg,] *   
     //					outer( rep(1,nrow(f.yi.qk[group==gg,])) , pi.k[,gg] ) ) ) )  
       
     for (int nn=0;nn<N;++nn){  
         double total = 0; 	  
         for (int tt=0;tt<TP;++tt){  
               total += FYIQK(nn,tt) * PIK[tt] ;  
                             } // end tt  
         LL += log( total )*DAT1[nn] ;  
                 }  // end nn  
                           
                           
     ///////////////////////////////////////////////////////  
     ///////////// O U T P U T   ///////////////////////////  
     return List::create(_["nk"] = NK , _["njk"] = NJK ,   
                     _["rjk"] = RJK , _["ll"] = LL );   
     	  
       
     /// print output on R console  
     //		Rcpp::Rcout << "hier:" << std::endl << nn << std::endl;					
END_RCPP
}



