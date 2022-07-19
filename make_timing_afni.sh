# use afni tools to make random timing

#quantum task
#cue 1 s
#first ITI 3s
#probe 1.5s
#second ITI 3s
#fb 0.5s
#ITI 3s


echo 0 99999 > quantum_design_eff.txt
for n in $(seq 1 10000); do

make_random_timing.py -num_runs 1 -run_time 480                \
-add_timing_class cue_stim 1 1 1 basis='TWOGAM(8.6,0.547,0.2,8.6,0.547)'                          \
-add_timing_class probe_stim 1.5 1.5 1.5 basis='TWOGAM(8.6,0.547,0.2,8.6,0.547)'                          \
-add_timing_class fb_stim 0.5 0.5 0.5 basis='TWOGAM(8.6,0.547,0.2,8.6,0.547)'                          \
-add_timing_class rest 1 3 9                       \
-add_timing_class ITIrest 1.2 3 9                       \
-add_stim_class cue 40 cue_stim rest                  \
-add_stim_class probe 40 probe_stim rest                  \
-add_stim_class fb 40 fb_stim ITIrest                  \
-ordered_stimuli cue probe fb                 \
-pre_stim_rest 0 -post_stim_rest 6                   \
-rand_post_stim_rest yes                              \
-prefix QuantumITI_afni/stimes.${n} \
-save_3dd_cmd cmd.3dd.txt \
-write_event_list QuantumITI_afni/events.${n}  -show_rest_events

cat QuantumITI_afni/events.${n} | tail -n 120 | awk '{print $5}' > QuantumITI_afni/ITI${n}.txt

bash cmd.3dd.txt >& 3ddout
val=$(cat 3ddout | grep -o [0-9]\\.[0-9][0-9][0-9][0-9]$ | awk '{ sum += $1 } END { print sum }')
echo ${val} ${n}  >> quantum_design_eff.txt
rm cmd.3dd.txt

done

for n in $(sort quantum_design_eff.txt | awk '{print $2}' | head -n 20); do
echo $n
cp QuantumITI_afni/ITI${n}.txt QuantumITIs/ITI${n}.txt
done

# make_random_timing.py -num_runs 1 -run_time 480         \
# -pre_stim_rest 6 -post_stim_rest 6                 \
# -rand_post_stim_rest no                              \
# -num_stim 3 \
# -num_reps 40 \
# -stim_labels cue probe fb       \
# -ordered_stimuli cue probe fb \
# -write_event_list events.adv.3                       \
# -show_timing_stats                                   \
# -save_3dd_cmd cmd.3dd.eg3.txt                        \
# -seed 31415 -prefix stimes.adv.3
# -num_stim 3 -num_reps 40                                \
# -min_rest 1 -max_rest 9 \
# -stim_labels cue probe fb       \
# -stim_dur 1 1.5 0.5                                \