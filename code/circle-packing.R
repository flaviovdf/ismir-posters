
# Create some random circles, positioned within the central portion
# of a bounding square, with smaller circles being more common than
# larger ones.

ncircles <- 200
limits <- c(-50, 50)
inset <- diff(limits) / 3
rmax <- 20

xyr <- data.frame(
  x = runif(ncircles, min(limits) + inset, max(limits) - inset),
  y = runif(ncircles, min(limits) + inset, max(limits) - inset),
  r = rbeta(ncircles, 1, 10) * rmax)

# Next, we use the `circleLayout` function to try to find a non-overlapping
# arrangement, allowing the circles to occupy any part of the bounding square.
# The returned value is a list with elements for the layout and the number
# of iterations performed.

library(packcircles)

res <- circleLayout(xyr, limits, limits, maxiter = 1000)
cat(res$niter, "iterations performed")

# Now draw the before and after layouts with ggplot

library(ggplot2)
library(gridExtra)

## plot data for the `before` layout
dat.before <- circlePlotData(xyr)

## plot dta for the `after` layout returned by circleLayout
dat.after <- circlePlotData(res$layout)

doPlot <- function(dat, title)
  ggplot(dat) + 
  geom_polygon(aes(x, y, group=id), colour="brown", fill="burlywood", alpha=0.3) +
  coord_equal(xlim=limits, ylim=limits) +
  theme_bw() +
  theme(axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank()) +
  labs(title=title)

grid.arrange(
  doPlot(dat.before, "before"),
  doPlot(dat.after, "after"),
  nrow=1)
