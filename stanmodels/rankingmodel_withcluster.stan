// Ranking model with cluster data
// Author: David Issa Mattos
// Date: 1 Oct 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 int y[N_total]; //variable that indicates which one wins algo0 oor algo 1

 int <lower=1> N_algorithm; // Number of algorithms
 
 int <lower=1> algo0[N_total];
 int <lower=1> algo1[N_total];
 
 // //To model the influence of each benchmark
 int <lower=1> N_bm;
 int bm_id[N_total];
}

parameters {
  real a_alg[N_algorithm]; //Latent variable that represents the strength value of each algorithm
  real<lower=0> s;//std for the random effects
  matrix[N_algorithm, N_bm] Uij; //parameters of the random effects for cluster
}

model {
  real p[N_total];
  a_alg ~ normal(0,2);
  s ~ exponential(0.1);
  for (i in 1:N_algorithm)
  {
    for(j in 1:N_bm){
       Uij[i, j] ~ normal(0, 1);
    }
   
  }

  for (i in 1:N_total)
  {
     p[i] = (a_alg[algo1[i]] + s*Uij[algo1[i], bm_id[i]]) - (a_alg[algo0[i]] + s*Uij[algo0[i], bm_id[i]] ) ;
  }
  
  y ~ bernoulli_logit(p);
}

