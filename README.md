# IIOP demo

The identifier interoperability (IIOP) of 2 datasets is the ratio of the real-world concepts identified with the same identifier across the 2 datasets over the total of real-world objects identified within the two datasets that overlap. The relevance of the interoperability is the number of facts where real-world objects are mentioned.

In this projects we will demonstrate a workflow to calculate the IIOP and the relevance on a couple of datasets hosted at http://iiop.demo.thedatatank.com/test/.

## Step 0: what do you think?

In order to evaluate the score, we will ask you to first take a look at the datasets at http://iiop.demo.thedatatank.com/test/ and compare them to http://iiop.demo.thedatatank.com/test/reference. Give your own score to it for both the interoperability itself, as a relevance number for the interoperability.

You can use this questionnaire: https://docs.google.com/forms/d/1xb-Fz6KsCX92WYkcB_CRHI5RlewEHVvEJnkuiTaxzzQ

The results of the questionnaire can be found here: TBA

## Step 1: transforming towards triples

Tools such as open refine can be used to transform the datasets into triples. Each time, every id is concatenated with the URI of the dataset (e.g., http://iiop.demo.thedatatank.com/test/ghent1/kml1 for the identifier of the first row or http://iiop.demo.thedatatank.com/test/ghent1/long as the identifier of the concept of longitude).

Tools like [Open Refine](http://openrefine.org), [RML](http://semweb.mmlab.be/ns/rml) or [DataLift](http://datalift.org) can be used. These tools map data towards triples.

In this demo we have used Open Refine. The result of the mapping are put in the respective dataset folders in this repository.

## Step 2: 

