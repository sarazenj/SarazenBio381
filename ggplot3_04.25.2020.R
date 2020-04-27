# ---------------------------------------------
# bar plot geoms and colors in ggplot
# 25 Apr 2020
# JCS
# ---------------------------------------------

# Preliminaries --------------------------------
library(ggplot2)
library(ggthemes)
library(patchwork)
library(colorblindr)
library(colorspace)
library(ggsci)
library(wesanderson)
library(TeachingDemos)

char2seed("Summer sun")
d <- mpg
#####################################################
# bar plots
table(d$drv)


p1 <- ggplot(d,aes(x=drv)) + 
  geom_bar(color="black",
           fill="cornsilk") # don't need to call idenity function within geom_bar(), it is just an option
print(p1)

# aesthetic mapping for multiple groups in each bar
p1 <- ggplot(d, aes(x=drv,fill=fl)) + 
      geom_bar()
print(p1)
# stacks bars on top of one another

# stacking with color transparency, adjust alpha, which is color transparency of each bar
# alpha = 0 all colors invisible
# alpha = 1 all colors completely opaque

p1 <- ggplot(d, aes(x=drv,fill=fl)) + 
  geom_bar(alpha=0.3,position="identity") # identity makes them all go down to the zero mark
print(p1)
# hard to see the multiple colors, probably not the best option

# better to use position = fill for stacking
# with constant height
p1 <- ggplot(d, aes(x=drv,fill=fl)) + 
  geom_bar(position="fill")
print(p1)
# still can't really measure the values

# best to use position = dodge, which will generate multiple bars
p1 <- ggplot(d, aes(x=drv,fill=fl)) + 
  geom_bar(position="dodge", color="black",
           size=0.8)
print(p1)
# one thing is that the sizes of bars in each group differ because they are spread across the same area

# more typical bar plot has heights as values (mean, total)
d_tiny <- tapply(X=d$hwy,
                 INDEX=as.factor(d$fl),
                 FUN=mean)
d_tiny <- data.frame(hwy=d_tiny)
d_tiny <- cbind(fl=row.names(d_tiny),d_tiny)

p2 <- ggplot(d_tiny,aes(x=fl,y=hwy,fill=fl)) +
      geom_col() #geomcolumn, not bar
print(p2)

# much better for a box plot!
p2 <- ggplot(d,aes(x=fl,y=hwy,fill=fl)) +
  geom_boxplot()
print(p2)

# overlay the raw data
p2 <- ggplot(d,aes(x=fl,y=hwy)) +
  geom_boxplot(fill="thistle", outlier.shape=NA) + 
  geom_point()
print(p2)

# improve visualization of the data
p2 <- ggplot(d,aes(x=fl,y=hwy)) +
  geom_boxplot(fill="thistle", outlier.shape=NA) + 
  geom_point(position=position_jitter(width=0.1,
                                      height=0.7),
             color="gray60",size=2) # gray 0(back)-100(white)
print(p2)



# Color --------------------------------

# hue - wavelength of visible light
# saturation - intensity, vibrance
# lightness - black to white
# red, blue, green
# named colors in R
# pdf that specifies the R colors available in course materials

# Aesthetics
# attractive colors
# - large geoms (bars, boxplots), light, pale colors
# - small geoms, (points, lines), dark, vibrant colors
# color palettes that are visible to those who are color blind
# color palettes that convert well to black and white

# Information content
# use colors to group similar treatments
# neutral colors (black,grey,white) for control symbols
# smybolic colors, (heat=red, cool=blue, photosynthesis=green, oligotrophic=blue, infected=red)
# dies or stains, or even colors or organisms

# discrete scales - distinct groups

# continuous scales (as in a heat map)
# monochromatic (different shades of one color)
# 2-tone chromatic scale (from color x to color y)
# 3-tone divergent scale (from color x through color y to color z)

# consistent color scheme for manuscript
# use consistent colors within and between your figures

# got color suggestion ideas from colorbrewer website
my_cols <- c("#ca0020", "#f4a582", "#92c5de", "#0571b0")
# demoplot from colorspace package, needs a vector of colors, and a way to see it, to visualize the colors
demoplot(my_cols, "map")
demoplot(my_cols, "bar")
demoplot(my_cols, "scatter")
demoplot(my_cols, "spine")
demoplot(my_cols, "heatmap")
demoplot(my_cols, "perspective")

# can also use demoplot on any of the named colors
my_r_colors <- c("red","brown","cyan","green")
demoplot(my_r_colors, "pie")
