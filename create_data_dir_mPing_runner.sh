x=X
for h in 10 500 100;
do
    for i in 3;
    do
        for j in 6;
        do
            num=$h
            chr="Chr$i"
            depth=$j$x
            echo $chr, $depth
            bash create_data_dir_mPing.sh $chr $depth $num 
        done
    done
done

