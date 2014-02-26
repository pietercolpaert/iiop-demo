# IIOP demo

The identifier interoperability (IIOP) of 2 datasets is the ratio of the real-world concepts identified with the same identifier across the 2 datasets over the total of real-world objects identified within the two datasets that overlap. The relevance of the interoperability is the number of facts where real-world objects are mentioned.

In this projects we will demonstrate a workflow to calculate the IIOP and the relevance on a couple of datasets hosted at http://iiop.demo.thedatatank.com/test/.

## Step 0: what do you think?

In order to evaluate the score, we will ask you to first take a look at the datasets at http://iiop.demo.thedatatank.com/test/ and compare them to http://iiop.demo.thedatatank.com/test/reference. Give your own score to it for both the interoperability itself, as a relevance number for the interoperability.

You can use this questionnaire: https://docs.google.com/forms/d/1xb-Fz6KsCX92WYkcB_CRHI5RlewEHVvEJnkuiTaxzzQ/viewform#start=openform

The results of the questionnaire can be found here: TBA

## Step 1: Transforming the data towards triples

Tools such as open refine can be used to transform the datasets into triples. Each time, every id is concatenated with the URI of the dataset (e.g., http://iiop.demo.thedatatank.com/test/ghent1/kml1 for the identifier of the first row or http://iiop.demo.thedatatank.com/test/ghent1/long as the identifier of the concept of longitude).

Tools like [Open Refine](http://openrefine.org), [RML](http://semweb.mmlab.be/ns/rml) or [DataLift](http://datalift.org) can be used. These tools map data towards triples.

_Caveat lector: even when we would have a dataset in RDF, we would still concatenate each URI with the dataset URI: we need a unique identifier for each identifier used in each dataset._

In this demo we have used Open Refine. The result of the mapping are put in the respective dataset folders in this repository:
 * reference/reference.ttl
 * ghent1/ghent1.ttl
 * newyork/newyork.ttl
 * ghent2/ghent2.ttl
 * antwerp/antwerp.ttl

Using a command-line tool which can be installed on debian/ubuntu systems using `apt-get install raptor2-utils`, we have converted the datasets into n-triples.

For each dataset we did:
```bash
rapper -i turtle -o ntriples antwerp.ttl > antwerp.nt
```

This generated this amount of triples:

Dataset | number of triples
:------:|-------------------:
reference| 21
ghent1 | 48
newyork | 16
antwerp | 45
ghent2 | 24

## Step 2: Generating the list of identifiers

For each dataset, we generated a file containing all the IDs defined in a dataset. Using the n-triples file, we can generate this quickly using this bash command for each dataset:

```bash
cut -d" " newyork.nt -f1,2,3 --output-delimiter="
" | grep "^<" | sort | uniq > ids.txt
```

Dataset | number of IDs
:------:|-------------------:
reference| 12
ghent1 | 17
newyork | 9
antwerp | 18
ghent2 | 11

## Step 3: Getting the real world input



## Step 4: Making the calculations

