// Time to converge, Cox regression model
// Author: David Issa Mattos
// Date: 23 June 2020
//
//

data {
 int <lower=1> N_total; // Sample size
 real y[N_total]; // iteration where it was solved
 int event[N_total]; // Indicates if the event occured or not

 //To model each algorithm independently
 int <lower=1> N_algorithm; // Number of algorithms
 int algorithm_id[N_total]; //vector that has the id of each algorithm
 
 //To model the influence of the noise
 real x_noise[N_total];
 
 //To model the influence of each benchmark
 int <lower=1> N_bm;
 int bm_id[N_total];
}

parameters {
  
  //Fixed effect
  real a_alg[N_algorithm];//the mean effect given by the algorithms
  real b_noise[N_algorithm];//effect of noise
  // //Random effect. The effect of the benchmarks
  real a_bm_norm[N_bm];//the mean effect given by the base class type
  real<lower=0> s;//std for the random effects
  
}

model {
  
  
  //Fixed effect
  a_alg ~ normal(0,10);
  
  // //Random effects
  s ~ exponential(0.1);
  a_bm_norm ~ normal(0,1);
  b_noise ~ normal(0,2);

  for (i in 1:N_total)
  {
    //uncensored data
    if(event[i]==1) target += exponential_lpdf(y[i] | exp(a_alg[algorithm_id[i]] + s*a_bm_norm[bm_id[i]] + b_noise[algorithm_id[i]]*x_noise[i])); 
    //censored data
    if(event[i]==0) target += exponential_lccdf(y[i] | exp(a_alg[algorithm_id[i]] + s*a_bm_norm[bm_id[i]] + b_noise[algorithm_id[i]]*x_noise[i]));  
  }
  
}


//Uncoment this part to get the posterior predictives and the log likelihood
//But note that it takes a lot of space in the final model
// //Here we suppose that the predictive data will not be censored.
// //But if it is above the budget we can censor it later
// generated quantities{
//   vector [N_total] y_rep;
//   vector[N_total] log_lik;
//   
//   for(i in 1:N_total){
//     real mu;
//     mu = a_alg[algorithm_id[i]] + s*a_bm_norm[bm_id[i]] + b_noise[algorithm_id[i]]*x_noise[i];
//     y_rep[i]= exponential_rng(mu);
//     
//     //uncensored data
//     if(event[i]==1) log_lik[i]= exponential_lpdf(y[i] | exp(a_alg[algorithm_id[i]] + s*a_bm_norm[bm_id[i]] + b_noise[algorithm_id[i]]*x_noise[i])); 
//     //censored data
//     if(event[i]==0) log_lik[i]= exponential_lccdf(y[i] | exp(a_alg[algorithm_id[i]] + s*a_bm_norm[bm_id[i]] + b_noise[algorithm_id[i]]*x_noise[i]));  
//   }
// }
