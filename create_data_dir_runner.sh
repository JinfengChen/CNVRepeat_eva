x=X
for i in {3..4};
do
    for j in 1 2 3 4 5 6 7 8 9 10 15 20 40;
    do
        chr="Chr$i"
        depth=$j$x
        echo $chr, $depth
        bash create_data_dir.sh $chr $depth 
    done
done
