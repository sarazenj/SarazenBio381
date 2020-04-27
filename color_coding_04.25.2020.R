# ---------------------------------------------
# more on colors! (pt 2)
# 25 Apr 2020
# JCS
# ---------------------------------------------

# Preliminaries --------------------------------
library(ggplot2)
library(ggthemes)
library(patchwork)
library(cowplot)
library(colorspace)
library(colorblindr)
library(ggsci)
library(wesanderson)
library(TeachingDemos)

char2seed("Summer sun")
d <- mpg
#####################################################

# working with black and white -------------------------------- 
# gray colors and grey functions

# built in grey colors (0 = black, 100 = white)
my_greys <- c("grey20","grey50","grey80")
demoplot(my_greys, "bar")

# using gray function! 
my_greys2 <- gray(seq(from=0.1,
                      to=0.9,
                      length.out = 10))
print(my_greys2)
demoplot(my_greys2,"heatmap")

# convert color plots to black and white
p1 <- ggplot(d,aes(x=as.factor(cyl),
                   y=cty,
                   fill=as.factor(cyl))) +
  geom_boxplot()
plot(p1)

# :: comes from that package
p1_des <- colorblindr::edit_colors(p1, desaturate)
plot(p1_des)
###### can't get the colorblindr package to work??

# desaturate with custom colors
p2 <- p1 + scale_fill_manual(values=c("red","blue","green","yellow"))
plot(p2)

p2_des <- colorblindr::edit_colors(p1, desaturate)
plot(p2_des)

# using alpha transparency for histograms
x1 <- rnorm(n=100,mean=0)
x2 <- rnorm(n=100,mean=2.7)
d_frame <- data.frame(v1=c(x1,x2))
lab <- rep(c("Control","Treatment"),each=100)
d_frame <- cbind(d_frame,lab)
str(d_frame)

h1 <- ggplot(d_frame,aes(x=v1,fill=lab))
h1 + geom_histogram(postion="identity",
                    alpha=0.3,
                    color="black")

# color customization in ggplot
d <- mpg

# discrete classification
# scale_fill_manual() - use for big geoms that have space to be filled, like histograms, boxplots, bars
# scale_color_manual() - for lines, points

# boxplot with no color
p_fil <- ggplot(d,aes(x=as.factor(cyl),y=cty))
p_fil + geom_boxplot()

# boxplot with default fill
# boxplot with no color
p_fil <- ggplot(d,aes(x=as.factor(cyl),y=cty,
                      fill=as.factor(cyl)))
p_fil + geom_boxplot()

# create custom color palette
my_cols <- c("red","brown","brown","orange")
p_fil + geom_boxplot() +
  scale_fill_manual(values=my_cols)

# scatterplot with no color
p_col <- ggplot(d,aes(x=displ,y=cty)) +
  geom_point(size = 3)
print(p_col)

# scatter default ggplot colors
p_col <- ggplot(d,aes(x=displ,
                      y=cty,
                      col=as.factor(cyl))) +
  geom_point(size = 3)
print(p_col)
p_col

# scatterplot with custom colors
p_col + scale_color_manual(values=my_cols)

# continuous classification for color gradient

# default color gradient (because hwy is continuous)
p_grad <- ggplot(d,aes(x=displ,
                       y=cty,
                       col=hwy)) + 
  geom_point(size=3)
print(p_grad)

# custom sequential gradient (2 colors)
p_grad + scale_color_gradient(low="green",
                              high="red")

# custom diverging gradient (3 colors)
mid <- median(d$hwy)
p_grad + scale_color_gradient2(midpoint=mid,
                               low="blue",
                               mid="white",
                               high="red")

# custom diverging gradient (n colors)
p_grad + scale_color_gradientn(colors=c("blue",
                                        "green",
                                        "yellow",
                                        "purple"))
# not a very useful color scale, but can be done


# Palette tour --------------------------------

library(wesanderson)
print(wes_palettes)
demoplot(wes_palettes$BottleRocket1,"pie")
demoplot(wes_palettes[[2]][1:3],"spine")

my_cols <- wes_palettes$GrandBudapest2[1:4]
p_fil + geom_boxplot() + scale_fill_manual(values=my_cols)

library(RColorBrewer)
display.brewer.all() # puts out full set of brewer colors

display.brewer.all(colorblindFriendly = TRUE)

demoplot(brewer.pal(4,"Accent"),"bar")
demoplot(brewer.pal(11,"Spectral"),"heatmap")

demoplot(c("#993404","#fec44f"),"pie")

# works well to put them into a vector, and then call the vector for filling in colors in the graph, for scale_fill_manual
my_cols <- c("gray75", brewer.pal(3,"Blues"))
print(my_cols)

p_fil + geom_boxplot() + scale_fill_manual(values=my_cols)
 
# nice tool for seeing hex values and colors together
library(scales)
show_col(my_cols)

# viridis palettes --------------------------------

### making a heat map
x_var <- 1:30
y_var <- 1:5
my_data <- expand.grid(x_var=x_var,y_var=y_var)
head(my_data)

z_var <- my_data$x_var + my_data$y_var + 2*rnorm(n=150)
my_data <- cbind(my_data,z_var)

head(my_data)

# default gradients in r
p4 <- ggplot(my_data,aes(x=x_var,
                         y=y_var,
                         fill=z_var)) +
  geom_tile()
print(p4)

# user defined divergent palette
p4 + scale_fill_gradient2(midpoint=19,
                          low="brown",
                          mid=gray(0.8),
                          high="darkblue")

# use viridis continuous scale - maximizies the range over what we can see
p4 + scale_fill_viridis_c() 

# options viridis, cividis, magma, inferno, plasma
p4 + scale_fill_viridis_c(option="cividis") 
p4 + scale_fill_viridis_c(option="magma") 
p4 + scale_fill_viridis_c(option="inferno") 
p4 + scale_fill_viridis_c(option="plasma") 

# desaturation
p4 <- p4 + scale_fill_viridis_c()
p4_des <- edit_colors(p4,desaturate)
plot(p4_des)
