


min_cases <- 10

#keep reqd cols
loc_cols  <- c('Country','State','FIPS','Combined_Key')
stat_cols <- c('Confirmed','Deaths','Recovered','Active')
misc_cols <- c('Update')
app_cols <- c(loc_cols, stat_cols, misc_cols)


app_colnames_1 <- c('Confirmed', 'Deaths')
app_colnames_2 <- c('Update','State','FIPS','Combined_Key')



#############
# Constants #
#############


# Designate clean, unique column names
drop_these   <- c( 'Update', 'Lat', 'Long', 'Admin', 'Combined_Key' )
leave_these  <- c( 'Active', 'Confirmed', 'Deaths', 'Recovered' )
rename_these <- c( 'Country', 'State', 'FIPS' )

all_colnames <- c( drop_these, leave_these, rename_these )


# Columns to keep for visualization
voi <- c( 'Confirmed', 'Deaths', 'Recovered', 'Active' )
goi <- c( 'State', 'Country' )


#######
# UDF #
#######

# Match raw column name against all clean names
get_clean_colname <- function( test_clean_name, test_colname ) {
	if( grepl( test_clean_name, test_colname ) ) {test_clean_name}
}




