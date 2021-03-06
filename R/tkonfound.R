#' Perform sensitivity analysis for a 2x2 table
#' @description This function calculates the number of cases (RIS) that would have to be switched from one cell to another of a 2x2 table to invalidate an inference made about the association between the rows and columns. This can be applied to treatment vs control with successful vs unsuccessful outcomes.
#' @param a cell is the number of cases in the control group showing unsuccessful results
#' @param b cell is the number of cases in the control group showing successful results
#' @param c cell is the number of cases in the treatment group showing unsuccessful results
#' @param d cell is the number of cases in the treatment group showing successful results
#' @param thr_p the p-value threshold used to evaluate statistical significance, with the default of 0.05
#' @param switch_trm whether switching the two cells in the treatment row or the two cells in the control row, with the default of the treatment row
#' @return prints a 2x2 table after switching cases from one cell to another so that the inference is invalidated about the association between the rows and columns 
#' @examples
#' # using tkonfound for a 2x2 table
#' tkonfound(35, 17, 17, 38)
#' tkonfound(35, 17, 17, 38, thr_p = 0.01)
#' tkonfound(35, 17, 17, 38, thr_p = 0.01, switch_trm = FALSE)
#' @export

tkonfound <- function(a, b, c, d, thr_p = 0.05, switch_trm = T){
# a <- 35
# b <- 17
# c <- 17
# d <- 38
# thr_p <- 0.05
# switch_trm <- T

# stop message
if (a <= 0 || b <= 0 || c <= 0 || d <= 0) {
  stop("Please enter positive integers for each cell.")
}

if (a != as.integer(a) || b != as.integer(b) || c != as.integer(c) || d != as.integer(d)) {
stop("Please enter positive integers for each cell.")
}

odds_ratio <- a*d/(b*c)
n_cnt <- a+b
n_trm <- c+d
n_obs <- n_cnt + n_trm
est <- log(odds_ratio)

# this is the 2 by 2 table we start with
table_ob <- matrix(c(a, b, c, d), byrow = TRUE, 2, 2)
p_ob <- chisq_p(a, b, c, d)
chisq_ob <- chisq_value(a, b, c, d)

# get solution
solution <- getswitch_chisq(a, b, c, d, thr_p, switch_trm)
  
table_final <- solution$Transfer_Table
table_start <- table_ob
dcroddsratio_ob <- solution$dcroddsratio_ob
allnotenough <- solution$needtworows
final <- solution$final_switch
p_final <- solution$p_final
chisq_final <- solution$chisq_final
taylor_pred <- solution$taylor_pred
perc_bias_pred <- solution$perc_bias_pred
final_extra <- solution$final_extra
total_switch <- solution$total_switch

### add column and row names to contingency tables
rownames(table_start) <- rownames(table_final) <- c("Control", "Treatment")
colnames(table_start) <- colnames(table_final) <- c("Fail", "Success")

if (switch_trm && dcroddsratio_ob) {
  transferway <- "treatment success to treatment failure,"
}
if (switch_trm && !dcroddsratio_ob) {
  transferway <- "treatment failure to treatment success,"
}
if (!switch_trm && dcroddsratio_ob) {
  transferway <- "control failure to control success,"
}
if (!switch_trm && !dcroddsratio_ob) {
  transferway <- "control success to control failure,"
}

if (allnotenough) {
  if (switch_trm && dcroddsratio_ob) {
    transferway_extra <- "control failure to control success,"
  }
  if (switch_trm && !dcroddsratio_ob) {
    transferway_extra <- "control success to control failure,"
  }
  if (!switch_trm && dcroddsratio_ob) {
    transferway_extra <- "treatment success to treatment failure,"
  }
  if (!switch_trm && !dcroddsratio_ob) {
    transferway_extra <- "treatment failure to treatment success,"
  }
}

if (p_ob < thr_p) {
  change <- "To invalidate the inference,"
} else {
    change <- "To sustain an inference,"
} 

if (!allnotenough & final > 1) {
  conclusion1 <- paste(
    change, sprintf("%d cases need to be transferred from", final),
    transferway, c("as shown, from the User-entered Table to the Transfer Table.")
  )
} 

if (!allnotenough & final == 1) {
  conclusion1 <- paste(
    change, sprintf("%d case needs to be transferred from", final),
    transferway, c("as shown, from the User-entered Table to the Transfer Table.")
  )
}

if (allnotenough){
  conclusion1 <- paste(
    change, c("only transferring cases from"), transferway,
    sprintf("is not enough. We also need to transfer %d cases from", final_extra),
    transferway_extra, c("as shown, from the User-entered Table to the Transfer Table.")
  )
}

conclusion2 <- sprintf(
  "For the User-entered Table, we have a Pearson's chi square of %.3f, with p value of %.3f.", chisq_ob, p_ob)
conclusion3 <- sprintf(
  "For the Transfer Table, we have a Pearson's chi square of %.3f, with p value of %.3f.", chisq_final, p_final)

info1 <- "The tkonfound function calculates the number of cases that would have to be switched from one cell to another of a 2x2 table to invalidate an inference made about the association between the rows and columns. This can be applied to treatment vs control with successful vs unsuccessful outcomes."
info2 <- "See konfound_fig for full and accessible details in graphic form!"

result <- list(info1, info2,
               conclusion1,
                 User_enter_value = table_start, Transfer_Table = table_final,
                 conclusion2, conclusion3)

  return(result)
}



