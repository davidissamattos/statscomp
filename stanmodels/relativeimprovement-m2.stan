// Relative improvement model - with a different sset of prior
// Author: David Issa Mattos
// Date: 17 June 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 real y[N_total]; // relative improvement variable

 //To model each algorithm independently
 int <lower=1> N_algorithm; // Number of algorithms
 int algorithm_id[N_total]; //vector that has the id of each algorithm
 
 //To model the influence of each benchmark
 int <lower=1> N_bm;
 int bm_id[N_total];
}

parameters {
  real <lower=0> sigma;//std for the normal
  
  //Fixed effect
  real a_alg[N_algorithm];//the mean effect given by the algorithms

  // //Random effect. The effect of the benchmarks
  real a_bm_norm[N_bm];//the mean effect given by the base class type
  real<lower=0> s;//std for the random effects
  
}

model {
  real mu[N_total];

  sigma ~ normal(0,5);
  
  //Fixed effect
  a_alg ~ normal(0,1);
  
  // //Random effects
  s ~ normal(0,5);
  a_bm_norm ~ normal(0,5);

  for (i in 1:N_total)
  {
    
     mu[i] = a_alg[algorithm_id[i]] + a_bm_norm[bm_id[i]]*s;
  }
  
  y ~ normal(mu, sigma);
}

generated quantities{
  vector [N_total] y_rep;
  vector[N_total] log_lik;
  for(i in 1:N_total){
    real mu;
    mu = a_alg[algorithm_id[i]] + a_bm_norm[bm_id[i]]*s;
    y_rep[i]= normal_rng(mu, sigma);
    log_lik[i] = normal_lpdf(y[i] | mu, sigma );
  }
}
