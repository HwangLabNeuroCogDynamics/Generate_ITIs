

# for alpha, 42 trials 360 seconds
for i in $(seq 1 1 10); do 

	optseq2 --ntp 240 --tr 1.5 --psdwin 0 18 1.5 --ev evt1 4.5 42 --nkeep 1 --nsearch 10000 --o search --tnullmin 1.5 --tnullmax 10.5
	cat search-001.par | grep NULL | awk '{print $3}' > AlphaITIs/ITI${i}.txt

done


# for ThalHi, 48 trials 360 seconds
for i in $(seq 1 1 10); do 

	optseq2 --ntp 240 --tr 1.5 --psdwin 0 18 1.5 --ev evt1 3 48 --nkeep 1 --nsearch 10000 --o search --tnullmin 1.5 --tnullmax 10.5
	cat search-001.par | grep NULL | awk '{print $3}' > ThalHiITIs/ITI${i}.txt

done


# for quantum, 35 compound trials (70), 210 TRs
for i in $(seq 1 1 10); do 

	optseq2 --ntp 210 --tr 2 --psdwin 0 18 1 --ev cue 1.5 80 --tnullmin 1.5 --tnullmax 10 --nsearch 10000 --ar1 rho --nkeep 1 --o search
	cat search-001.par | grep NULL | awk '{print $3}' > QuantITIs/ITI${i}.txt

done