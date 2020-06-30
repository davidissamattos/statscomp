// Relative improvement model - without cluster
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
}

parameters {
  real <lower=0> sigma;//std for the normal
  
  //Fixed effect
  real a_alg[N_algorithm];//the mean effect given by the algorithms
}

model {
  real mu[N_total];

  sigma ~ exponential(1);
  
  //Fixed effect
  a_alg ~ normal(0,1);

  for (i in 1:N_total)
  {
    
     mu[i] = a_alg[algorithm_id[i]];
  }
  
  y ~ normal(mu, sigma);
}

generated quantities{
  vector [N_total] y_rep;
  vector[N_total] log_lik;
  for(i in 1:N_total){
    real mu;
    mu = a_alg[algorithm_id[i]];
    y_rep[i]= normal_rng(mu, sigma);
    log_lik[i] = normal_lpdf(y[i] | mu, sigma );
  }
}
