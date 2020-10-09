#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double rcpp_sum(NumericVector v){
  double sum = 0;
  for(int i = 0; i < v.length(); ++i){
    sum += v[i];
  }
  return(sum);
}