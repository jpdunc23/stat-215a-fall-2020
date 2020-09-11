z_theme <- function() {
  library(RColorBrewer)
  # Generate the colors for the chart procedurally with RColorBrewer
  palette <- brewer.pal("Greys", n=9)
  color.background <- palette[2]
  color.grid.major <- palette[3]
  color.axis.text <- palette[7]
  color.axis.title <- palette[7]
  color.title <- palette[8]
  # Begin construction of chart
  theme_bw(base_size=9) +
    theme(
      # Set the entire chart region to a light gray color
      panel.background = element_rect(
        fill=color.background, color=color.background
      ),
      plot.background = element_rect(
        fill=color.background, color=color.background
      ),
      panel.border = element_rect(color=color.background),
      # Format the grid
      panel.grid.major = element_line(color=color.grid.major,size=.25),
      panel.grid.minor = element_blank(),
      axis.ticks = element_blank(),
      # Format the legend, but hide by default
      legend.position = "none",
      legend.background = element_rect(fill=color.background),
      legend.text = element_text(size=7,color=color.axis.title),
      # Set title and axis labels, and format these and tick marks
      plot.title = element_text(color=color.title, size=20, vjust=1.25),
      axis.text.x = element_text(size=14,color=color.axis.text),
      axis.text.y = element_text(size=14,color=color.axis.text),
      axis.title.x = element_text(size=16,color=color.axis.title, vjust=0),
      axis.title.y = element_text(size=16,color=color.axis.title, vjust=1.2)
    )
}
