#par(mfrow=c(2,4))
#invisible(sapply(c('il','ny','ca','wi','ok','fl','tx','ks'), plot_inf_rate))


plot_inf_rate <- function( in_state ) {

	# Convert abbreviation to full state name
	if( nchar(in_state) == 2) {
		in_state <- state.name[which(state.abb == toupper(in_state))]
	}

	# Subset data for state of interest
	tmp <- subset(ds_7, State == in_state)
	
	# add infection rate per 100k people
	tmp[, 'rate_pop']  <- tmp[,'Population'] / tmp[,'Confirmed']
	tmp[, 'rate_100k'] <- 100000 / ( tmp[,'Population'] / tmp[,'Confirmed'] )

	#plot_tmp <- subset(tmp, State == 'Florida')
	plot_tmp <- tmp
	plot(plot_tmp[,'Update'], plot_tmp[,'rate_100k'])
	ss_2 <- smooth.spline(plot_tmp[-1,"Update"], plot_tmp[-1,"rate_100k"], df = 10)
	lines(ss_2, lty = 2, col = "red")
	
}

