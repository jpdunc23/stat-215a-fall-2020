# STAT 215A, Fall 2020

This is the github repository for STAT 215A, Fall 2020.

Thanks to Tiffany Tang, Zoe Vernon, Rebecca Barter, and other past GSI's for
sharing their material with me. This document was originally written by Rebecca
for STAT 215A in the Fall of 2017 and has been slightly modified in subsequent
years.

Questions and discussions between students can be posted on Piazza ([signup
link](https://piazza.com/berkeley/fall2020/stat215a)). That way everyone else
can see your questions and the answers, and we don't have to answer the same
questions a million billion times. Preferably you will answer each other's
questions. It is our intention to only jump in when the question is one that
only we can answer.

Please think carefully before asking questions specifically about the projects.
For example, questions concerning how to do something specific in R (e.g. "how
do I convert a list of lists to a long-form data frame?") are fine, but
questions asking what other people did for their analysis are not (e.g. "what
are some findings that people have come across in the Redwood project?").
Questions asking about clarifications are fine.

# Class times

**Lectures**:

Tuesdays & Thursdays, 11-12:30, Zoom

**Labs**:

Fridays, 11-1, Zoom

**Office Hours**:

*Bin*: Tuesdays 1:30-2:30, Thursdays 1-2, Zoom

*James*: Mondays 2-4, Thursdays 2-4, Zoom

# Class website

bCourses and https://yu-group.github.io/stat-215a-fall-2020/

# Useful resources

The following resources are excellent for both learning R and becoming a more advanced user.

- [R for Data Science](https://r4ds.had.co.nz/), a free online book written by Hadley Wickham and Garrett Grolemund.

- The [tidyverse website](http://www.tidyverse.org/). Much of what makes R powerful is the collection of packages developed by Hadley Wickham and the other lovely people over at RStudio encompassed in a the so-called "tidyverse". The tidyverse website provides a summary of all of its packages. The particularly useful ones will be `ggplot2` and `dplyr`.

- The ["Tidy Data"](https://www.jstatsoft.org/article/view/v059i10/v59i10.pdf) paper by Hadley Wickham will give you a feel for how to effectively mold in R your data for maximizing ease of usefulness. Note that the `reshape2` package is essentially obsolete and have been replaced by the `tidyr` package (part of the tidyverse). Specifically, the functions `melt` and `cast` have been replaced by the more intuitively named functions `gather` and `spread`, respectively.

We will also be using Git and GitHub a lot in this course. Here are some resources for figuring out what Git is and how to use it.

- For information on installing Git and setting up GitHub see their [website](https://github.com/).

- Software Carpentry has a thorough [Git and GitHub tutorial](http://swcarpentry.github.io/git-novice/) available for free.


# The lab assignments

There will be 4-5 lab reports throughout the semester. These reports are a *big deal*. It is in completing these reports that the real learning happens. You will get to apply what you've learned in the lectures and labs to real datasets (with real issues). You will also learn to develop a narrative that reports your scientific findings as accurately and accessibly as possible: you will learn to tell a story with your analysis.

While you are allowed to discuss the projects with one another, each student must work on and hand in their own report. If you do consult with other students, please acknowledge these students in your lab reports. 


The current tentative dates for the labs are as follows:

| Project title                  | Date released | Due date                | Peer grade submission date |
|--------------------------------|---------------|-------------------------|----------------------------|
| Redwood trees                  | September 4   | September 17 (2 weeks) | September 27               |
| Linguistic Survey              | September 25  | October 08 (2 weeks)    | October 18                 |
| Stability of Linguistic Survey | October 13    | October 22 (1.5 weeks)  | (graded by James)        |
| *Midterm*                      | October 29    |                         |                            |
| Cloud detection (group project)| October 30 | November 12 (2 weeks)   | (graded by James)        |
| Covid-19 (final project)   | November 13   | December 04 (3 weeks)   | (graded by James)        |



## The reports

Each report will be up to 12 pages (.pdf format) and will contain (1) a description of the problem, (2) a description of the data, (3) a description of the data cleaning procedure, (4) a description of the analytic methods, (5) a description of your results, and (6) relevant visualizations in all five stages.
There is no predetermined structure of the report, and it is entirely free form. There are only a few real requirements:

1. No code is to appear in the final pdf report.

1. Your report must not exceed 12 pages.

1. You must make an effort to communicate effectively. Think as if you are writing a blog post or an informal journal article.

1. The data from each lab comes from an existing research paper, which will be given to you. You must also make an effort to incorporate domain information and knowledge in the writeup to give the report some context. For example, it is good habit to explain in the introduction why your problem is important within the domain, to describe any connections between the statistical models/algorithms and the true phenomenon at hand, and to conclude with a discussion of the impacts of the results within the domain context. Ideally, domain knowledge should be incorporated at all stages of the data science pipeline.

1. Favour simplicity over complexity. It is much more important to be thorough and to communicate effectively than to come up with some super fancy modeling idea that no one understands. If a super fancy is needed or justified, then feel free to go for it.

Keep in mind that there are two types of visualization: *exploratory* and *explanatory*. Exploratory visualizations are graphics that you produce to help *you* understand the data, whereas explanatory visualizations are final versions of a small subset of these figures that you produce to explain to *other people* what is in the data. Typically you will produce many, many exploratory plots and only a few key explanatory plots that answer specific questions. Choose your explanatory plots carefully, and ask the following question of every figure in your report: "Does this figure add anything? Is my story strictly worse when I remove it?" If the answer to either question is "no", then you should remove the figure. Just because you spent a lot of time making a really pretty figure, doesn't mean that it adds anything to your story. There have been many times in my life where I have spent an hour or two making a really awesome plot only to decide the next day that it is actually fairly irrelevant to my main points and removing it.

You will also be submitting your code, and you should write it nicely according to the Google R Style Guide (https://google.github.io/styleguide/Rguide.xml).

## Setting up GitHub for this class

Your report and code will be submitted via GitHub. The following instructions will show you how to set up your GitHub account and configure a repository so that you can submit your assignments. This workflow is shamelessly copied (with slight modifications) from Chris Paciorek and Jarod Millman's setup from STAT243 in 2014.

1. Install Git on your system (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

1. Sign up for GitHub (https://github.com/).

1. Go to https://education.github.com/ and sign up for the student pack to get unlimited private repositories. You are a "student" and you want an "individual account".

Once you have completed these first steps, you are then ready to create your private GitHub repository for this class.

1. Locally on your machine, clone my stat-215-a repository: `git clone https://github.com/tiffanymtang/stat-215-a`. This will create a copy of the repository on your own computer.

1. On the GitHub website, log in and create a **private** remote repository called *stat-215-a*. Add me (*tiffanymtang*) as a collaborator for this repository (check out settings on the repo website).

1. Back in the terminal, change directories to the stat-215-a folder and set the origin of your local repository to be the remote repository that you just made: `git remote set-url origin https://github.com/USERNAME/stat-215-a.git` (Change USERNAME below to your username). This tells git which remote repository to push your changes to when you `git push`.

1. Edit *info.txt* to reflect your own information.

```
name = "Jane Smith"
SID = "0123456789"
email = "jsmith@berkeley.edu"
github_name = "janesmith"
```

Now you're ready to push to your remote repository for the first time:

1. Check git status `git status`. You should see a bunch of text including `modified:   info.txt`.

1. Add (`git add info.txt`) and commit (`git commit -m “Updated info.txt with my own information”`) your edited *info.txt* file

1. Push your changes to your copy of the remote repository (`git push` or sometimes `git push remote origin`)

1. Check that info.txt has been updated in your remote github repository by navigating to https://github.com/USERNAME/stat-215-a (change USERNAME to your username)

## Submitting your projects

To submit your projects, you will need to create a subfolder in your local `stat-215-a` folder called `lab1` (if you are submitting lab 1). Inside this folder you should have the following (exact) structure:

```
lab1/
  data/
  documents/
  homework.pdf
  lab1.Rmd
  lab1.pdf
  lab1_blind.Rmd
  lab1_blind.pdf
  R/
  other/
```

- The source of your report (with code) will be contained in the `lab1.Rmd` file.

- The compiled version of your report will be contained in `lab1.pdf`.

- You will also submit a "blind" version of each of these documents that does not include your name (`lab1_blind.Rmd` and `lab1_blind.pdf`).

- The `R/` folder will contain any extra R scripts needed to compile your report.

- The `data/` folder will contain any data you use for the lab.

- The `homework.pdf` file will contain your completed homework. Please do not include any irrelevant files.

- The `documents/` folder will contain any relevant papers or documents for the project.

Note that GitHub cannot host files more than 100 MB. If you try to push a file larger than this, GitHub will cry.

When you are ready, you need to add, commit, and push the `lab1/` folder.

At the time when the lab is due, I will run a script that automatically pulls all of your assignments into my local versions of your `stat-215-a` repositories. Please make sure to submit your labs on time. We will spend some time in the first lab having everyone submit a pretend assignment so that you are all clear on what to do.

## Peer-grading

While you probably did a lot of really cool stuff in your own report, an excellent way to learn about other cool things is to see what other people did! This includes other exploratory and modeling ideas, neat R tricks, and issues with the data that you didn't notice or think of when you were doing your own analysis. So that you each have the opportunity to see a splattering of alternative approaches to the labs, we will be doing peer-grading for this class.

For a couple of the labs, you will each receive 2 reports from your peers to grade. A detailed rubric will be provided and you will be expected to provide both written feedback as well as a numeric grade on a variety of topics including communication, quality of data cleaning, relevance of visualizations, and reproducibility (can you easily re-compile their report). 

After you have all submitted your own assignments (and shortly after the deadline), I will run a script that will automatically push two randomly selected reports into a folder called lab1_review/. To retrieve your allocated reports, you will need to git pull. You will have one week to review these two reports and return your feedback in the form of a google questionnaire that I will send by email to you all. I will use these two grades for your report as a guide for grading, rather than as a final decision on your grade.


## Frequently asked questions

**Do I have to use R? Can I use Python instead?**

Yes, R is required for several reasons.

1. The ability to embed R code, text and LaTeX formulae in RStudio is excellent and makes reproducibility a breeze.

1. Since we are doing peer reviewing, which includes a code-review, it will be *so* much easier for everyone if we are all using the same language.

**Can I write my report using Jupyter Notebooks?**

No, sorry. One of the ways that we are ensuring that the reports are a reasonable length is to require a 12 page or less length limit. We also don't want to see any code in your final report.

**When should I start working on my lab?**

The labs, if done properly, will take you a long time. Ideally, you should be writing the report simultaneously with your analysis in order to avoid a last minute hacking together of all of your analyses. Do not leave starting the lab until the last minute. You should start as soon as you receive the lab and work on it a little bit every day (rather than in one massive chunk). If you can easily do an entire lab in less than a week, then you have missed a lot in the data cleaning process.
