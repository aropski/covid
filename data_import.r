###############################################################################
# JHU uses Date format %m-%d-%Y								 	 			  #			
# lubridate uses       %Y-%m-%d									 			  #
###############################################################################

# No inputs are considered Factors
# All NAs are converted to zeroes
# Any NAs and <NA>s are evidence of new columns added to DB
# Active column is given
# An imputed active value will be used as: Confirmed - Deaths - Recovered


library('dplyr')
#library('lubridate')
library('RCurl')

setwd(  )
source( "./functions/default_vars.r" )
source( "./functions/update_jhu_db.r" )
source( "./functions/get_jhu_daily.r" )
source( "./functions/update_populations.r" )


# run for all dates
update_jhu_db(remove_master = FALSE, get_daily = TRUE)


# update populations
#update_country_pop()
#update_state_pop()

# supply user-defined dates
#sapply( "01-22-2020", update_jhu_db, remove_master = TRUE, get_daily = TRUE)

load('./data/master_data.RData')

