# ADD FILTER FOR DAY ZERO
# first Confirmed > n
# first Death > n

#	ds_1: all master_data rows, app_cols
#	ds_2: filter ds_1 for Country == 'US' & 50 base state names
#	ds_3: adds state level freqs; summate from county level data
#	ds_4: filter ds_3 for min_cases
#	ds_5: adds daily differnce
#	ds_6: most recent daily report

library('plyr') 
library('data.table')
library('forecast')
 
setwd(  )

load('./data/master_data.RData')
load('./data/pop_country.RData')
load('./data/pop_state.RData')

# import all functions in subdirs; ignore backup files
func_paths <- paste0('./functions/', dir('./functions/'))
invisible(lapply( func_paths[grep(".r$", func_paths)], source ))


### FIX AUTO RUN REPORT
rpts_paths <- paste0('./reports/', dir('./reports/'))
invisible(lapply( rpts_paths[grep(".r$", rpts_paths)], source ))


# update population counts; saves and returns
#pop_country <- update_country_pop()
#pop_state   <- update_state_pop()

# Clean country population and filter jhu
cleaned_data <- clean_country_names(master_data, pop_country)
master_data <- cleaned_data[['master_data']]
pop_country <- cleaned_data[['pop_country']]

# Filter for data with matched country population
master_data <- inner_join(master_data, pop_country, by = 'Country')

# keep columns of interest
ds_1 <- subset( master_data, select = app_cols )


# summarize by country
ds_20 <- ddply(ds_1, c('Country','Update'), county_to_state, app_colnames=app_colnames_1)


# 50 states from base R 'state.name'
tmp_1 <- subset( ds_1, Country == 'US' )
ds_2  <- tmp_1[ tmp_1$State %in% state.name, ]


# Sum required to add up all county/FIPS level data into statewide total
ds_3 <- ddply(ds_2, c('State','Update'), county_to_state, app_colnames=app_colnames_1)


# filter date: start > 10 cases
ds_4  <- ddply(ds_3,   c('State'),   remove_low_cases, min_cases)
ds_21 <- ddply(ds_20,  c('Country'), remove_low_cases, min_cases)


# add daily diff, enforce continuous
ds_5  <- ddply(ds_4,   c('State'),   compute_daily_diff, app_colnames=app_colnames_1, level = 'State' )
ds_22 <- ddply(ds_21,  c('Country'), compute_daily_diff, app_colnames=app_colnames_1, level = 'Country' )
ds_22 <- ds_22[!is.na(ds_22$Country),]


if(FALSE){
	par(mfrow=c(1,1))
	tmp <- subset(ds_22, Country=='US')
	plot(tmp$Update, tmp$Confirmed)
	ss_1 <- smooth.spline(tmp[-1,"Update"], tmp[-1,"Confirmed"], df = 10)
	lines(ss_1, lty = 2, col = "black")
}

# add daily inc w/ pop
ds_7  <- left_join(ds_5,  pop_state,   by = "State")
ds_23 <- left_join(ds_22, pop_country, by = "Country")


# most recent daily report
ds_6  <- ddply(ds_5,  c('State'),   return_daily_count)
ds_24 <- ddply(ds_23, c('Country'), return_daily_count)

state_ordered   <- ds_6[order(ds_6$Confirmed, decreasing = TRUE),]
country_ordered <- ds_24[order(ds_24$Confirmed, decreasing = TRUE),]


# get most recent daily report w/ pop
tmp <- daily_w_state_pop( left_join(ds_6, pop_state, by = "State") )



################ 
# COUNTY LEVEL #
################ 

# get filtered state, join in county level by Update & State
ds_10 <- ds_2[!is.na(ds_2$FIPS), c(app_colnames_2, app_colnames_1) ]

ds_11 <- inner_join(ds_5[,c('Update','State')], ds_10, by=c('Update','State'))

# review for FIPS missing dates
ds_12 <- ddply(ds_11, c('FIPS'),  compute_daily_diff, app_colnames=app_colnames_1 )



 