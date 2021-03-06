# Script: lemmatizer.R
# 
# see http://morphadorner.northwestern.edu/morphadorner/server/corpusconfigservice/ 


# A script written and distributed as a teaching
# aid for demonstrating how to perform corpus
# lemmatization in R.  The script demonstrates the use
# of the Morphadorner lemmatizing service to 
# create a lemmatized version of a single text.
#
# For alternate language openNLPModels see http://datacube.wu.ac.at/src/contrib/
#
# Because the code is designed for teaching, it
# aims for step by step clarity rather than code
# efficiency.  Experienced programmers will see
# many ways that this code could be made more
# efficient and elegant in terms of both processing
# speed and memory management.  The code as
# presented is designed to allow a novice coder
# to follow the logic of the script as intuitively
# as possible. With this in mind, the following
# conventions are used throught the code:
#
# (1) In order to facilitate distinguishing between
# variables, functions, and objects all variables in 
# the code begin with the "var_" prefix.
#
# (2) In order to facilitate distinguishing a
# a variable's type or class, all variables are
# names using a _suffix that identifies the 
# variable type.
#
# (3) In order to facilitate distinguishing between
# variables, functions, and objects all objects in 
# the code begin with the "obj_" prefix.
#
# (4) Locally defined functions begin with the 
# function_ prefix
#
# Copyright Carl G. Stahmer - 2016
# Director of Digital Scholarship - UC Davis Library
# Associate Director for Humanities - Data Science Initiative
# Associate Director - English Broadside Ballad Archive
#
# Portions of this code are based on Matt Jockers'
# Introduction to text analysis with R:
#
# Jockers, M. (2014). 
# _Text Analysis with R for Students of Literature_
# Quantitative Methods in the Humanities and Social …. 
# doi:10.1007/978-3-319-03164-4
#
# This work is licensed under a Creative Commons 
# Attribution-ShareAlike 4.0 International License.
#
# see http://creativecommons.org/licenses/by-sa/4.0/

# install.packages("httr")
# install.packages("XML")

library(httr)
library(XML)

###################################
#         configuration           #
###################################

# set the file path
#filePath.str = "data/plainText/melvyl.txt"

var_input_file <- "/Users/cstahmer/workspaces/rstudio_workspace/text_mining_with_r/data/ballads/20001.txt"



###################################
#      function declarations      #
###################################

lemmatize <- function(wordlist) {
  get.lemma <- function(word, url) {
    response <- GET(url,query=list(spelling=word,standardize="",
                                   wordClass="",wordClass2="",
                                   corpusConfig="eme",    # Nineteenth Century Fiction eme = early modern ece = 18th century
                                   media="xml"))
    content <- content(response,type="text")
    xml     <- xmlInternalTreeParse(content)
    return(xmlValue(xml["//lemma"][[1]]))    
  }
  url <- "http://ebba.ds.library.ucdavis.edu:8080/maserver/lemmatizer"
  #url <- "http://morphadorner.northwestern.edu/morphadorner/maserver/lemmatizer"
  return(sapply(wordlist,get.lemma,url=url))
}

# A callable function that writes out the contents
# of a vector in human readable form.
function_show_vector <- function(var_vec_to_show_vector) {
  for(i in 1:length(var_vec_to_show_vector)) { 
    cat(i, var_vec_to_show_vector[i], "\n", sep=" ")
  } 
}

###################################
#        Operational Code         #
###################################

# Do a test run
# words <- c("is","am","was","are")
# lemmatize(words)

# Now do a real run

# load the file to be analized into a character vector
# the resulting vector will have as many elements as
# lines in the file with the contents of each line
# contained in a character vector.
var_text_lines <- readLines(var_input_file, warn = FALSE)

# convert to lower case
var_text_lines <- tolower(var_text_lines)

# collapse the vector of lines into a single character 
# vector
var_text_blob <- paste(var_text_lines, collapse = " ")

# split each line on spaces
var_text_words_list <- strsplit(var_text_blob, "\\W")

# unlist to a word vector
var_text_words <- unlist(var_text_words_list)

# do the lemmatization
var_lemmatized_words <- lemmatize(var_text_words[50:60])

# output results
function_show_vector(var_lemmatized_words)
