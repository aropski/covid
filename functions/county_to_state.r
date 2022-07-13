county_to_state <- function(in_data, app_colnames) {

	coi <- colnames(in_data) %in% app_colnames
	
	#sum columns
	daily_tots <- colSums(in_data[,coi])
	
	return( daily_tots )
	
	
}

#by_country <- aggregate(. ~ State * Update, ds_2[, c('State', 'Update', app_colnames)], sum)
#t1 <-       ds_3[with(ds_3, order(State,Update)), ]
#t2 <- by_country[with(by_country, order(State,Update)), ]
