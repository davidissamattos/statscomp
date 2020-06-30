compile_book <- function(){
  bookdown::render_book('index.Rmd', 'all')
  #Creating a file called .nojekyll for github pages
  file.create('./docs/.nojekyll')
  generate_tables()
}



create_table_model <- function(stanfit, pars, renamepars){
  if(length(pars)!=length(renamepars)) print("ERROR different size vectors")
  hpdi <- get_HPDI_from_stanfit(stanfit)
  stanfit_summary <- as_tibble(summary(stanfit)$summary, rownames="Parameter")
  
  t1<-stanfit_summary %>% 
    dplyr::filter(Parameter %in% pars) %>% 
    select(Parameter,n_eff, Rhat)
  t2<-hpdi %>% 
    dplyr::filter(Parameter %in% pars)
  t<-left_join(x=t2,y=t1, by=c("Parameter")) %>% 
    dplyr::select(Parameter,Mean, everything()) %>% 
    dplyr::mutate(Parameter=renamepars)
  return(t)
}

create_one_csv_from_folder<-function(savename, loadpath='./', savepath='./')
{
  all_files <- list.files(path=loadpath, full.names = T)
  dat_csv <- plyr::ldply(all_files, read_csv,
                         col_types = cols() #suppress the bunch of messages it generates
  )
  
  mergedcsv <-glue::glue(savepath,savename)
  write_csv(dat_csv,mergedcsv)
}

create_index <- function(x){
  index <- as.integer(as.factor(x))
  return(index)
}

get_index_names_as_array <- function(x){
  arr <- as.array(as.character(levels(as.factor(x))))
  return(arr)
}

print_stan_code <- function(filename)
{
  sourcecode <- paste(readLines(filename), collapse="\n")
  cat(sourcecode)
}


get_HPDI_from_stanfit<- function(stanfit)
{
  require(coda)
  hpdi<-coda::HPDinterval(coda::as.mcmc(as.data.frame(stanfit)))
  estimate<-as.data.frame(summary(stanfit)$summary)$mean
  df<-tibble::rownames_to_column(as.data.frame(hpdi), "Parameter")
  df.hpdi<-mutate(df,
             Mean=as.data.frame(summary(stanfit)$summary)$mean) %>%
    rename(HPDI.lower=lower, HPDI.higher=upper)
  return(df.hpdi)
}

save_fig <- function(p, name, type="two-column"){
  path <- glue::glue('./statscomp-paper/figures/',name)
  
  if(type=="two-column")
  {
    ggsave(filename = path,
           width = 210,
           height = 70,
           units = "mm",
           plot = p,
           device = 'pdf')
  }

  if(type=="single-column")
  {
    ggsave(filename = path,
           width = 105,
           height = 120,
           units = "mm",
           plot = p,
           device = 'pdf')
  }
}

save_parameter_table <- function(in_path, out_path, caption="Estimated parameters of the model", label, table.env="table*"){
  kable(readRDS(in_path), 
        "latex", 
        table.envir = table.env,
        caption=caption, 
        booktabs=T,
        label=label,
        format.args = list(scientific = FALSE), digits = 3,
        linesep = "") %>% 
    # footnote(general = "n_eff is the number of effective samples \n Rhat is the Gelman-Rubin potential scale reduction",
    #          footnote_as_chunk = T, 
    #          title_format = c("italic")
    # ) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines(out_path)
}

save_data_table <- function(in_path, out_path, caption, label,table.env="table"){
  kable(readRDS(in_path), 
        "latex", 
        table.envir = table.env,
        caption=caption, 
        booktabs=T,
        label=label,
        format.args = list(scientific = FALSE), digits = 3,
        linesep = "") %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines(out_path)
}


generate_tables<-function(){
  
  # Probability of success
  save_data_table(in_path = './statscomp-paper/tables/datafortables/probsuccessmodeldata.RDS', 
                  out_path = './statscomp-paper/tables/probsuccessmodeldata.tex', 
                  caption = "Illustrating the data used in probability of success model (sample of four rows)",
                  label = 'probsuccessmodeldata',
                  table.env = "table*")
  
  save_parameter_table(in_path ='./statscomp-paper/tables/datafortables/probsuccess-par-table.RDS' ,
                       out_path = './statscomp-paper/tables/probsuccess-par-table.tex',
                       label = 'probsuccesspartable')
  
  #Relative improvement
  save_data_table(in_path = './statscomp-paper/tables/datafortables/relativeimprovementmodeldata.RDS', 
                  out_path = './statscomp-paper/tables/relativeimprovementmodeldata.tex', 
                  caption = "Illustrating the data used in relative improvement model (sample of four rows)",
                  label = 'relativeimprovementmodeldata',
                  table.env = "table*")
  
  save_parameter_table(in_path =  './statscomp-paper/tables/datafortables/relativeimprovement-par-table.RDS',
                       out_path =  './statscomp-paper/tables/relativeimprovement-par-table.tex',
                       label = 'relativeimprovementpartable' )
  
  #Ranking data 
  save_data_table(in_path =  './statscomp-paper/tables/datafortables/rankingtmodeldata.RDS', 
                  out_path = './statscomp-paper/tables/rankingtmodeldata.tex' , 
                  caption = "Illustrating the data used in the Bradley Terry model for ranking (sample of 6 rows)" ,
                  label =  'rankingtmodeldata',
                  table.env = "table*")
  
  save_data_table(in_path =  './statscomp-paper/tables/datafortables/rankingalgorithmsresults.RDS', 
                  out_path = './statscomp-paper/tables/rankingalgorithmsresults.tex' , 
                  caption = "Ranking the algorithms based on the reward difference" ,
                  label =  'rankingalgorithmsresults')
  
  save_parameter_table(in_path =  './statscomp-paper/tables/datafortables/ranking-par-table.RDS',
                       out_path =  './statscomp-paper/tables/ranking-par-table.tex',
                       label = 'rankingpartable' )
  
  # time to converge

  save_data_table(in_path =  './statscomp-paper/tables/datafortables/timetoconvergedata.RDS', 
                  out_path = './statscomp-paper/tables/timetoconvergedata.tex', 
                  caption = "Illustrating the data used in the Cox Proportional Hazards model time to converge to a solution (sample of 6 rows)",
                  label =  'timetoconvergedata',
                  table.env = "table*")
  
  save_data_table(in_path =  './statscomp-paper/tables/datafortables/hr_table.RDS', 
                  out_path = './statscomp-paper/tables/hr.tex', 
                  caption = "Average baseline coefficient and the average noise hazard ratio",
                  label =  'hr')
  
  save_parameter_table(in_path =  './statscomp-paper/tables/datafortables/timetoconverge-par-table.RDS',
                          out_path =  './statscomp-paper/tables/timetoconverge-par-table.tex',
                          label = 'timetoconvergepartable' )
  
  #Multiple groups comparison
  
  save_data_table(in_path =  './statscomp-paper/tables/datafortables/multiplegroupsdata.RDS', 
                  out_path = './statscomp-paper/tables/multiplegroupsdata.tex', 
                  caption ="Illustrating the data used in the roobust multiple groups comparison (sample of 6 rows)",
                  label =  'multiplegroupsdata',
                  table.env = "table*")
  
  save_parameter_table(in_path =  './statscomp-paper/tables/datafortables/multiplegroupsdifference-par-table.RDS', 
                  out_path = './statscomp-paper/tables/multiplegroupsdifference-par-table.tex', 
                  label =  'multiplegroupsdifferenceartable')
  
  save_data_table(in_path =  './statscomp-paper/tables/datafortables/multiplegroupsdifference.RDS',
                  caption= "HPDI interval for the difference between the groups",
                       out_path =  './statscomp-paper/tables/multiplegroupsdifference.tex',
                       label = 'multiplegroupsdifference' )
}
