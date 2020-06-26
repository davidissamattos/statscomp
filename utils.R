compile_book <- function(){
  bookdown::render_book('index.Rmd', 'all')
  #Creating a file called .nojekyll for github pages
  file.create('./docs/.nojekyll')
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

save_table <- function(table, name){
  path <- glue::glue('./statscomp-paper/tables/',name, '.tex')
  readr::write_lines(table, path)
}

generate_tables<-function(){
  kable(readRDS('./statscomp-paper/tables/datafortables/probsuccessmodeldata.RDS'), 
        "latex", 
        caption="Illustrating the data used in probability of success model (sample of four rows)", 
        booktabs=T, label='probsuccessmodeldata',format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/probsuccessmodeldata.tex')
  
  kable(readRDS('./statscomp-paper/tables/datafortables/relativeimprovementmodeldata.RDS'), 
        "latex",
        caption="Illustrating the data used in relative improvement model (sample of four rows)", 
        label = "relativeimprovementmodeldata" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>%
    readr::write_lines('./statscomp-paper/tables/relativeimprovementmodeldata.tex')
  
  
  kable(readRDS('./statscomp-paper/tables/datafortables/rankingtmodeldata.RDS'),
        "latex",
        caption="Illustrating the data used in the Bradley Terry model for ranking (sample of 6 rows)", label = "rankingtmodeldata" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/rankingtmodeldata.tex')

  kable(readRDS('./statscomp-paper/tables/datafortables/rankingalgorithmsresults.RDS'), 
        "latex",
        caption="Ranking the algorithms based on the reward difference", 
        label = "rankingalgorithmsresults" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/rankingalgorithmsresults.tex')
  
  

  kable(readRDS('./statscomp-paper/tables/datafortables/timetoconvergedata.RDS'),
        "latex",
        caption="Illustrating the data used in the Cox Proportional Hazards model time to converge to a solution (sample of 6 rows)", 
        label = "timetoconvergedata" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/timetoconvergedata.tex')

  kable(readRDS('./statscomp-paper/tables/datafortables/multiplegroupsdata.RDS'), "latex",caption="Illustrating the data used in the roobust multiple groups comparison (sample of 6 rows)", label = "multiplegroupsdata" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/multiplegroupsdata.tex')
  
  
  
  kable(readRDS('./statscomp-paper/tables/datafortables/multiplegroupsdifference.RDS'), 
        "latex",caption="HPDI interval for the difference between the groups", 
        label = "multiplegroupsdifference" ,booktabs=T, format.args = list(scientific = FALSE), digits = 3) %>% 
    kable_styling(latex_options = c("hold_position"),
                  full_width = F) %>% 
    readr::write_lines('./statscomp-paper/tables/multiplegroupsdifference.tex')
}
