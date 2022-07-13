

# state infection rate trend
# build off continuous data set ds_5
# lookup state pop from pop_state

# add daily rate by pop
add_daily_rate_pop <- function( in_data, pop_state ) {

	ds_8 <- ddply(ds_7, c('State'), add_pop_rate)


}

