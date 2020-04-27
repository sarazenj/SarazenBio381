# ---------------------------------------------
# ggplot multiple plots and aesthetics
# 24 Apr 2020
# JCS
# ---------------------------------------------

# preliminaries
library(ggplot2)
library(ggthemes)
library(patchwork)
char2seed("Spring")
d <- mpg # use mpg data set

# Multiple plots --------------------------------

# create a set of plots

g1 <- ggplot(data=d,
             mapping=aes(x=displ,y=cty)) +
            geom_point() +
            geom_smooth()
print(g1)

g2 <- ggplot(data=d,
             mapping=aes(x=fl,
                         fill=I("tomato"),color=I("black"))) +
  geom_bar(stat="count")
  theme(legend.position = "none")
print(g2)

g3 <- ggplot(data=d,
             mapping=aes(x=displ,
                         fill=I("royalblue"),
                                color=I("black"))) +
               geom_histogram()
print(g3)

# fl is a discrete variable
g4 <- ggplot(data=d,
             mapping=aes(x=fl,y=cty,fill=fl)) +
            geom_boxplot() +
            theme(legend.position = "none")
print(g4)

# use patchwork to combine plots

# place two plots horizontally
g1 + g2

# place 3 plots vertically
g1 + g2 + g3 + plot_layout(ncol=1)

# change relative area of each plot
g1 + g2 + plot_layout(ncol=1,heights=c(2,1))

g1 + g2 + plot_layout(ncol=2,widths=c(1,2))

# add a spacer plot, leaves a space in the middle to add something else to later
g1 + plot_spacer() + g2

# use nested plots
g1 + {
  g2 + {
    g3 + 
      g4 +
      plot_layout(ncol=1)
  }
} + 
  plot_layout(ncol=1)

# - operator for subtrack element
g1 + g2 - g3 + plot_layout(ncol=1) # - sign puts g3 at the bottom and the plot_layout() stretches it across the whole column

# / and | for intuitive plot layouts
(g1 | g2 | g3)/g4

(g1 | g2)/(g3 | g4) 

# add a title, subtitle to patchwork
g1 + g2 + plot_annotation("This is a title",
                          caption="made with patchwork") # caption shows up at the bottom

# change the styling of patchwork annotations
g1 + g2 + 
  plot_annotation(
    title = "This is a title",
    caption = "made with patchwork",
    theme = theme(plot.title = element_text(size=16)))

# Add tags to plots - adds labels A, B, C to the names of each graph
g1 / (g2 | g3) +
  plot_annotation(tag_levels = 'A')


# Swapping axes, orientation --------------------------------
g3a <- g3 + scale_x_reverse()
g3b <- g3 + scale_y_reverse()
g3c <- g3 + scale_x_reverse() + scale_y_reverse()

(g3 | g3a)/(g3b | g3c)

# coordinate flipping
(g3 + coord_flip() | g3a + coord_flip())/
  (g3b + coord_flip() | g3c + coord_flip())



# Aesthetic mappings --------------------------------

# mapping of discrete variable to point color
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          color=class))) + 
  geom_point(size=3)
print(m1)

# mapping of a discrete variable to point shape (<= 6 groups)
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          shape=class))) + 
  geom_point(size=3)
print(m1)
# this takes out one of the classes because max discrete variables is 6, and we have 7, so the last one is taken out

# mapping of a discrete variable to point shape (not recommended)
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          size=class))) + 
  geom_point()
print(m1)

# not recommended because the discrete variables, the car names, get alphabetically assigned to the size of the dot, doesn't really make sense

# mapping a continuous varaible to point size
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          size=hwy))) + 
  geom_point()
print(m1)

# map two variables to different aesthetics
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          shape=class,
                          color=hwy))) + 
  geom_point(size=5)
print(m1)

# use shape for a smaller number of categories
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          shape=drv,
                          color=fl))) + 
  geom_point(size=5)
print(m1)
# each point has an X and Y value, shape and the drive type

# use all 3 (size, shape, color) to indicate 5 data attributes!
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          shape=drv,
                          color=fl,
                          size=hwy))) + 
  geom_point()
print(m1)

# mapping to the same aesthetic in two different geoms

m1 <- ggplot(data=d,
             mapping=aes(x=displ,
                         y=cty,
                         color=drv)) +
  geom_point(size=2) + geom_smooth(method="lm")
print(m1)


# Faceting --------------------------------

# basic faceting with variables split by row, column or both
m1 <- ggplot(data=d,
             mapping=aes(x=displ,y=cty)) +
  geom_point()
m1 + facet_grid(class~fl)

# scaling of x and y axis is the same in each graph, but can't always see relationships within each plot

# change axes by letting some of them be free, changes the y axis scale
m1 + facet_grid(class~fl, scales="free_y")

# let both axes be free in scale
m1 + facet_grid(class~fl, scales="free_x") 

# facets also work with one-way layout
m1 + facet_grid(.~class)

# one way layout with differing rows
m1 + facet_grid(class~.)


# facet wrap when variables are not crossed

m1 + facet_grid(.~class)
m1 + facet_wrap(.~class) # not connected to one another, strings together the values we have

# add a second variable to facet_wrap, each of the combinations of the two variables. we only see combinations of data that we actually had
m1 + facet_wrap(~class + fl)

# include "empty" combos in facet_wrap, even ones that don't have points
m1 + facet_wrap(~class + fl,drop=FALSE)

# contrast with grid two-way layout
m1 + facet_grid(class~fl)

# use facet with other aesthetic mappings within rows or columns
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          color=drv))) +
  geom_point()
m1 + facet_grid(.~class)


# easy to switch to other geoms. se is standard error
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,
                          y=cty,
                          color=drv))) +
  geom_smooth(se=FALSE,method="lm") # gives us the regression line, but not the uncertainty in the se
m1 + facet_grid(.~class)

# fitting boxplots with a continuous variable
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,y=cty))) +
  geom_boxplot()
m1 + facet_grid(.~class)

# add a "group" and fill the mappings for subgroups
m1 <- ggplot(data=d,
             mapping=(aes(x=displ,y=cty, group=drv, fill=drv))) +
  geom_boxplot()
  m1 + facet_grid(.~class)

  # broken each box plot into individual box plots


# Aesthetic mappings 2 --------------------------------

  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy)) +
    geom_point() + geom_smooth()
  print(p1)
  
# break out drive types (note what "group" affects)
  
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy,
                           group=drv)) +
    geom_point() + geom_smooth()
  print(p1)

# break out drive types (note what "color" affects)
  
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy,
                           color=drv)) +
    geom_point() + geom_smooth()
  print(p1)

# color designation only does colors for lines or points.
  
# break out drive types (note what "fill" affects)
  
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy,
                           fill=drv)) +
    geom_point() + geom_smooth()
  print(p1)
# color of the confidence interval is only thing that changes
  
# color both the points and confidence interval
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy,
                           color=drv,fill=drv)) +
    geom_point() + geom_smooth()
  print(p1)

  
# use aesthetic mappings to overide defaults
# subset data to plot what is needed
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy,
                           color=drv)) +
    geom_point(data=d[d$drv=="4",]) + geom_smooth()
  print(p1)
  
# data=d[d$drv=="4"] = subsetting, grab the data for just the 4 wheel drive data

# instead of subsetting, just map an aesthetic
  p1 <- ggplot(data=d,
               mapping=aes(x=displ, y=hwy)) +
    geom_point(mapping=aes(color=drv)) + geom_smooth()
  print(p1)
  
  # mapping can happen in different places, this code changed it to the geom_point(), not for the whole plot, overrides the original mapping. The points are mapped within the point 
  
# conversely, map the smoother, but not the points
p1 <- ggplot(data=d, mapping=aes(x=displ,y=hwy)) +
  geom_point() + geom_smooth(mapping=aes(color=drv))
print(p1)
# points are all back here


# also, subset in the first layer to eliminate some data entirely
# instead of subsetting, just map an aesthetic
p1 <- ggplot(data=d[d$drv!="4",], mapping=aes(x=displ,y=hwy)) +
  geom_point(mapping=aes(color=drv)) + geom_smooth()
print(p1)