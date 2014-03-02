datasetname=newyork;
alltriples=$( cat reference/reference.nt $datasetname/$datasetname.nt | sort | uniq ; );
grep -E "reference/(.*?)> <http://semweb.mmlab.be/ns/iiop#sameAs> <http://.*?/$datasetname/\1>" iiopstatements.nt | cut -d" " -f1,3 | { while read id1 id2 ; do
    joined=${id1/http:\/\/iiop.demo.thedatatank.com\/test\/reference/http:\/\/example.com\/joined};
     #joined=${id2/http:\/\/iiop.demo.thedatatank.com\/test\/$datasetname/http:\/\/example.com\/joined};
    alltriples=${alltriples//$id1/$joined} ;
    alltriples=${alltriples//$id2/$joined} ;
    #echo "$alltriples" | grep joined; 
done ;
echo "$alltriples" | sort | uniq > $datasetname/joined_reference.nt ;
}
cut -d" " -f1,2,3 --output-delimiter="
" $datasetname/joined_reference.nt | grep '/joined' | wc -l
alltriples=$( cat reference/reference.nt $datasetname/$datasetname.nt | sort | uniq ; );
grep -E "reference/.*?> <http://semweb.mmlab.be/ns/iiop#sameAs> <http://.*?/$datasetname/.*?>" iiopstatements.nt | cut -d" " -f1,3 | { while read id1 id2 ; do
    joined=${id1/http:\/\/iiop.demo.thedatatank.com\/test\/reference/http:\/\/example.com\/joined};
    #joined=${id2/http:\/\/iiop.demo.thedatatank.com\/test\/$datasetname/http:\/\/example.com\/joined};
    alltriples=${alltriples//$id1/$joined} ;
    alltriples=${alltriples//$id2/$joined} ;
done ;
echo "$alltriples" | sort | uniq > $datasetname/joined_max_reference.nt ;
}
cut -d" " -f1,2,3 --output-delimiter="
" $datasetname/joined_max_reference.nt | grep '/joined' | wc -l