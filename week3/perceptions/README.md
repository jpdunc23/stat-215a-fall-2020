# Perceptions of Probability and Numbers

[This Reddit post](https://www.reddit.com/r/dataisbeautiful/comments/3hi7ul/oc_what_someone_interprets_when_you_say_probably/) made the Longlist for the 2015 Kantar Information is Beautiful Awards: [Link](http://www.informationisbeautifulawards.com/showcase/818-perceptions-of-probability)

This was last updated on 2017-08-25 ([reddit thread](https://www.reddit.com/r/dataisbeautiful/comments/6vythg/i_redid_my_perceptions_of_probability_and_numbers/)) in order to:

1. Update the code for ggplot version 2.2.1
2. Add a couple of ridge plots through the `ggjoy` package.

## About

These are a couple of polls inspired by the Sherman Kent CIA study shown in the images below (discussion in [this thread](https://np.reddit.com/r/dataisbeautiful/comments/3gmj6h/probable_is_a_vague_word_but_this_image_helps_ive/ctzgwhm)). I was super happy when they matched up.

The raw data came from /r/samplesize responses to the following question: *What [probability/number] would you assign to the phrase "[phrase]"?* I have the raw CSV data from the poll in this repository.

## Gallery

Sherman-Kent Study:

![Sherman-Kent Study](https://www.cia.gov/library/center-for-the-study-of-intelligence/csi-publications/books-and-monographs/psychology-of-intelligence-analysis/fig18.gif/image.gif)

/r/Samplesize Data:

![Reproduction of the Sherman-Kent Study](https://raw.githubusercontent.com/zonination/perceptions/master/plot1.png)

![Additional survey questions](https://raw.githubusercontent.com/zonination/perceptions/master/plot2.png)

With the new `ggjoy` package:

![Reproduction of the Sherman-Kent Study (ridge plot)](https://raw.githubusercontent.com/zonination/perceptions/master/joy1.png)

![Additional survey questions (ridge plot)](https://raw.githubusercontent.com/zonination/perceptions/master/joy2.png)

## Information

* Tool: The data was compiled with R, and graphed in ggplot2.
* Source: This data was gathered using Reddit's /r/samplesize community.
