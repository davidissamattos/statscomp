// Multiple group comparison
// Author: David Issa Mattos
// Date: 23 June 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 real y[N_total]; // time to complete variable

 //To model each algorithm independently
 int <lower=1> N_algorithm; // Number of algorithms
 int algorithm_id[N_total]; //vector that has the id of each algorithm
 
 //To model the influence of each benchmark
 int <lower=1> N_bm;
 int bm_id[N_total];
}

parameters {
  //Fixed effect
  real a_alg[N_algorithm];//the mean effect given by the algorithms
  real <lower=0> sigma[N_algorithm];//std for the student t

  // //Random effect. The effect of the benchmarks
  real a_bm_norm[N_bm];//the mean effect given by the base class type
  real<lower=0> s;//std for the random effects
  
  real<lower=0> nu;//std for the random effects
  
}

model {
  real mu[N_total];
  real sigma_i[N_total];

  sigma ~ exponential(1);
  nu ~ exponential(1.0/30.0);
  
  //Fixed effect
  a_alg ~ normal(0,1);
  
  // //Random effects
  s ~ exponential(1);
  a_bm_norm ~ normal(0,1);

  for (i in 1:N_total)
  {
    
     mu[i] = a_alg[algorithm_id[i]] + a_bm_norm[bm_id[i]]*s;
     sigma_i[i] = sigma[algorithm_id[i]];
  }
  
  y ~ student_t(nu, mu, sigma_i);
}

//Uncoment this part to get the posterior predictives and the log likelihood
//But note that it takes a lot of space in the final model
// generated quantities{
//   vector [N_total] y_rep;
//   vector[N_total] log_lik;
//   for (i in 1:N_total){
//     real mu;
//     real sigma_i;
//     mu = a_alg[algorithm_id[i]] + a_bm_norm[bm_id[i]]*s;
//     sigma_i = sigma[algorithm_id[i]];
//     y_rep[i] = student_t_rng(nu,mu,sigma_i);
//     
//     //Log likelihood
//     log_lik[i] = student_t_lpdf(y[i] | nu,mu,sigma_i);
//     
//   }
// }
