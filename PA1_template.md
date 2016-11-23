# rres_proj1
November 22, 2016  


# Setup - Load Data and Libraries
Load data


```r
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
activity.csv <-unzip(temp)
activity <- read.csv(activity.csv, sep=",", header = TRUE, stringsAsFactors = FALSE)
unlink(temp)
```

Load Libraries

```r
##Load libraries
library(dplyr)
library(lubridate)
library(lattice)
```

# What is mean total number of steps taken per day

#### 1) Calculate the Total number of steps taken per day

```r
step1 <- aggregate(steps ~ date, data = activity, sum)
colnames(step1)[2] <- "step_sum"
```

#### 2) Make a histogram of the total number of steps taken each day

```r
range <- length(step1$step_sum)
hist(step1$step_sum, breaks=range, main="Histogram of Total Steps Taken per Day", xlab = "Total Daily Steps", col = "green")
```

![](PA1_template_files/figure-html/hist1-1.png)<!-- -->

#### 3) Calculate and report the mean and median of the total number of steps taken per day

```r
tstepmean <- mean(step1$step_sum)
tstepmedian <- median(step1$step_sum)
```
mean = 10766

median = 10765

#### 4) Create a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
avesteps <- aggregate(steps ~ interval, data = activity, mean, na.rm=TRUE)
par(mfrow=c(1,1))
with(avesteps, plot(interval, steps, type = "l", main = "Average Number of Steps by 5min Interval averaged across all days", xlab = "5 min intervals over 24 hours period", ylab = "Number of steps"))
```

![](PA1_template_files/figure-html/avesteps-1.png)<!-- -->

#### 5) Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
b <- which.max(avesteps$steps)
c <- avesteps$interval[b]
d <- avesteps$steps[b]
```

The maximum number of steps were 206 
taken at military time 835 

# Imputing missing values

#### 1) Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)



The total number of rows with missing values is 2304.

#### 2) Devise a strategy for filling in all of the missing values in the dataset. 

Replacing NA values with mean step count.

#### 3) Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
activity2 <- activity 
m1 <- mean(activity$steps, na.rm = TRUE)
activity2$steps[is.na(activity2$steps)] <- m1
```

#### 4) Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 


```r
step2 <- aggregate(steps ~ date, data = activity, sum)
colnames(step2)[2] <- "step_sum"
range <- length(step2$step_sum)
hist(step2$step_sum, breaks=range, main="Histogram of Total Steps Taken per Day \n Imputed Dataset", xlab = "Total Daily Steps", col = "green")
```

![](PA1_template_files/figure-html/histogram1-1.png)<!-- -->

```r
astepmean <- mean(step2$step_sum)
astepmedian <- median(step2$step_sum)
```

mean total steps = 10766

median median total steps = 10765


#### 5) Do these values differ from the estimates from the first part of the assignment? 

No, as expected, using the mean and median to calculate the mean and median in a duplicate dataset should not shift those values.  However, the total number of steps taken will change.


#### 6) Create a difference of the two data sets


```r
k1 <- sum(activity2$steps) 
k2 <- sum(activity$steps, na.rm=TRUE) 
k3 <- k1 - k2
k3 
```

```
## [1] 86129.51
```

The difference in steps is 86130.

#### 7) What is the impact of imputing missing data on the estimates of the total daily number of steps?

86130 steps more in the imputed data from the original data. 

This is a 15 percent increase.

As expected, by definition total steps will increase when data is imputed since more data points with positive values will be counted for a positive valued dataset.

# Are there differences in activity patterns between weekdays and weekends?

#### Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.


```r
activity2[,4] <- NULL
activity2[,4] <- as.character()
colnames(activity2)[4] <- "w_day"
activity2$date <- ymd(activity2$date)
dayw <- c("Saturday", "Sunday")

p <- length(activity2$date)
for(i in 1:p)
    if(weekdays(activity2$date[i]) %in% dayw){activity2$w_day[i] <- "weekend"
    } else {
    activity2$w_day[i] <- "weekday"}
activity2[,4] <- as.factor(activity2[,4])
```

#### Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
activity22 <- aggregate(steps ~ interval + w_day, data = activity2, mean)
xyplot(steps~interval|w_day, data=activity22, 
       main="Steps by Interval", xlab="Interval",  ylab="Number of Steps",layout=c(1,2), type="l", lwd=1, col="black")
```

![](PA1_template_files/figure-html/panel_plot-1.png)<!-- -->

Findings:  weekend steps/intervals are higher after 9:00 than the weekday counts.
