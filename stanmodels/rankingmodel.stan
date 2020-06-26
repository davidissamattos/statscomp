// Relative improvement model
// Author: David Issa Mattos
// Date: 22 June 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 int y[N_total]; //variable that indicates which one wins algo0 oor algo 1

 int <lower=1> N_algorithm; // Number of algorithms
 
 int <lower=1> algo0[N_total];
 int <lower=1> algo1[N_total];
 
 // //To model the influence of each benchmark
 // int <lower=1> N_bm;
 // int bm_id[N_total];
}

parameters {
  real alpha[N_algorithm]; //Latent variable that represents the strength value of each algorithm
}

model {
  real p[N_total];

  alpha ~ normal(0,5);
  

  for (i in 1:N_total)
  {
     p[i] = alpha[algo1[i]] - alpha[algo0[i]];
  }
  
  y ~ bernoulli_logit(p);
}

