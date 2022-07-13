#par(mfrow=c(2,4))
#invisible(sapply(c('il','ny','ca','wi','az','fl','tx','ks'), plot_state))

plot_state <- function( in_state ) {

	#print(in_state)

	# Convert abbreviation to full state name
	if( nchar(in_state) == 2) {
		in_state <- state.name[which(state.abb == toupper(in_state))]
	}

	# Subset data for state of interest
	tmp <- subset(ds_5, State == in_state)

	# Plot Confirmed
	plot(tmp$Update, tmp$Confirmed, xlab = "", ylab = "") #New Confirmed Cases
	title(main = in_state)
	# Add smooth
	ss_1 <- smooth.spline(tmp[-1,"Update"], tmp[-1,"Confirmed"], df = 10)
	lines(ss_1, lty = 2, col = "black")
	
	# Add Death to same plot
	par(new = TRUE)
	plot(tmp$Update, tmp$Deaths, axes = FALSE, col='red', bty = "n", xlab = "", ylab = "")
	#mtext("Daily Death Count", side = 4, line = 2)
	# Add smooth
	ss_2 <- smooth.spline(tmp[-1,"Update"], tmp[-1,"Deaths"], df = 10)
	lines(ss_2, lty = 2, col = "red")
	axis(side=4, at = pretty(c(0,max(tmp$Deaths))))
		
	# split out to separate ggplot2 function
	if (FALSE) {	
			
		# Plot Confirmed
		state_plot <- ggplot(data = tmp, aes(x = Update, y = Confirmed)) +
			  geom_bar(stat = "identity", fill = "purple") +
			  labs(title = "Daily Report",
				   subtitle = in_state,
				   x = "Date", y = "Confirmed")
				  
		print(state_plot)
			  
	}
			  
}





