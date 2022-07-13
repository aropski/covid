

update_jhu_db <- function( remove_master = FALSE, 
						   get_daily     = TRUE, 
						   jhu_date      = NULL ) {
# Default action is to update with data from 01-20-2020 through Sys.date()
						   
	print('running update_jhu_db with inputs:')
	print(paste('remove_master:', remove_master))
	print(paste('get_daily', get_daily))
	print(paste('jhu_date', jhu_date))
		
	# Delete jhu db, if exists
	if( remove_master ) {	
		print( 'Attempting to delete the master_data.RData file...' )
		if( file.exists('./data/master_data.RData') ) {
			file.remove('./data/master_data.RData')
			remove( master_data ) 
			print('Deleted master_data.RData.')
		} else {
			print('Master data not available to delete.')
		}
	}
	

	# Import csvs from jhu github and save to db
	if( get_daily ) {
		
		# import master_data
		if( file.exists('./data/master_data.RData') ) {
			#if( exists('master_data') ) { remove( master_data ) }
			load('./data/master_data.RData')
			print('master_data imported with dimensions:')
			print( dim(master_data) )
		} else {
			print('master_data not available to import.')
		}
		
		
		# set process_dates
		if( !is.null( jhu_date ) ) { ### single, user-defined date ###
			
			print( paste('Using user-specified date of:', jhu_date) )
			process_dates <- as.Date( jhu_date, format = "%m-%d-%Y" )
			print( paste('Importing data for day of:', process_dates ) )
		
		} else { ### a range of dates ###
			
			data_start_date <- '01-22-2020' # 1st day availabile for jhu
			date_today      <- Sys.Date()

			# get available data dates
			dates_jhu  <- seq( as.Date(data_start_date, format = "%m-%d-%Y"), as.Date(date_today), by="days")

		
			# generate list of missing dates
			if( exists( "master_data" ) ) {
				dates_in_mydb <- as.Date( unique( master_data[, 'Update'] ) )
				# determine which days need to be added to DB
				process_dates <- dates_jhu[ !( dates_jhu %in% dates_in_mydb  ) ]
			} else {
				process_dates <- dates_jhu
			}
			
			print( 'Importing data for range of dates:' )
			print( process_dates )
		
		} # END PROCESS_DATES


		# loop through needed dates
			
		print('Final process_dates are: ')
		print(process_dates)

		for( process_date in process_dates ) {

			print(paste("Loop input variable: ", process_date))
			process_date <- as.Date( process_date, origin= '1970-01-01' )
			print(paste("As Date variable: ", process_date ))

			# import data from jhu
			daily_jhu_raw <- get_jhu_daily( process_date )
			
			if( is.null(daily_jhu_raw) ) { 
				print(paste("Data not available for:", process_date )) 
				break 
			}
			
			# report retrieved table dimensions
			print('csv from github returned with dimensions:')
			print( dim(daily_jhu_raw) )
		
			# Return ordered vector of cleaned names
			clean_colnames <- unlist( lapply( colnames( daily_jhu_raw ), function(x) {
				unlist( lapply(all_colnames, get_clean_colname, x) )
			}))

			# Replace with clean colnames
			colnames( daily_jhu_raw ) <- clean_colnames

			# Replace with formatted date
			daily_jhu_raw <- subset(daily_jhu_raw, select = -Update)
			daily_jhu_raw[, 'Update' ] <- as.Date( process_date )

			# Replace NA with zero
			daily_jhu_raw[ is.na(daily_jhu_raw) ] <- 0
			
			# Display cleaned names 
			print( head(daily_jhu_raw) ) 
			
			# Combine with existing
			if( exists( "master_data" ) ) {
				master_data <- dplyr::bind_rows(master_data, daily_jhu_raw)
			} else {
				master_data <- daily_jhu_raw
			}
			
			print(paste('Completed:', process_date ))
			remove(daily_jhu_raw)
			
		} # end for process_dates loop

		# Drop NA columns
		coi <- which( is.na(colnames(master_data)) )
		master_data <- master_data[, -coi]

		# Save final table 
		save( master_data, file = './data/master_data.RData' )
	
			
	} # END GET_DAILY

} # END FUNC