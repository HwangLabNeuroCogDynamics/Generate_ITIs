# use afni tools to make random timing
# https://afni.nimh.nih.gov/pub/dist/doc/program_help/make_random_timing.py.html

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

# evaulate delay schedule with 3dDeconvolve, the sort by std err of contrast
for n in $(sort quantum_design_eff.txt | awk '{print $2}' | head -n 20); do
echo $n
cp QuantumITI_afni/ITI${n}.txt QuantITIs/ITI${n}.txt
done
