// RRanking model with ties
// Author: David Issa Mattos
// Date: 23 Sept 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 int y[N_total]; //variable that indicates which one wins algo0 oor algo 1
 int ytie[N_total]; //variable that indicates if it was a tie


 int <lower=1> N_algorithm; // Number of algorithms
 

 
 int <lower=1> algo0[N_total];
 int <lower=1> algo1[N_total];
 
 // //To model the influence of each benchmark
 // int <lower=1> N_bm;
 // int bm_id[N_total];
}

parameters {
  real a_alg[N_algorithm]; //Latent variable that represents the strength value of each algorithm
  real <lower=0> nu; 
}

model {
  real p[N_total];

  a_alg ~ normal(0,2);
  nu ~ normal(0,2);

  for (i in 1:N_total)
  {
     p[i] = a_alg[algo1[i]] - a_alg[algo0[i]];
  //tie
    if(ytie[i]==1) target += exponential_lpdf(y[i] | inv_logit( log(nu*sqrt(p[i])*sqrt(1-p[i]))) ); 
    //no
    if(ytie[i]==0) target += exponential_lccdf(y[i] | inv_logit(p[i]) );  
  }
  
  y ~ bernoulli_logit(p);
}

