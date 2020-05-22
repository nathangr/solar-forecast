train_short:
	# Train the model with 100 trees
	mkdir -p results
	python3 train.py train_set_complete1.csv 100 | tee results/train_set_complete1_100_log.txt

train_long:
	# Train the model with 1000 trees
	mkdir -p results
	python3 train.py train_set_complete1.csv 1000 | tee results/train_set_complete1_1000_log.txt

all: clean convert subsets_dir headers split_data combine linearize_stations add_station_details add_gefs_data add_historical_data random_data_subset train_short
	# Scrap all the past data

clean:
	# Clean everything to start from scratch
	rm -rf csv_subsets
	#

convert:
	# convert NCDF4 to csv
	mkdir -p csv_data
	python3 nc2csv.py ncdf_data/apcp_sfc_latlon_subset_19940101_20071231.nc csv_data/apcp_sfc
	python3 nc2csv.py ncdf_data/dlwrf_sfc_latlon_subset_19940101_20071231.nc csv_data/dlwrf_sfc
	python3 nc2csv.py ncdf_data/dswrf_sfc_latlon_subset_19940101_20071231.nc csv_data/dswrf_sfc
	python3 nc2csv.py ncdf_data/pres_msl_latlon_subset_19940101_20071231.nc csv_data/pres_msl
	python3 nc2csv.py ncdf_data/pwat_eatm_latlon_subset_19940101_20071231.nc csv_data/pwat_eatm
	python3 nc2csv.py ncdf_data/spfh_2m_latlon_subset_19940101_20071231.nc csv_data/spfh_2m
	python3 nc2csv.py ncdf_data/tcdc_eatm_latlon_subset_19940101_20071231.nc csv_data/tcdc_eatm
	python3 nc2csv.py ncdf_data/tcolc_eatm_latlon_subset_19940101_20071231.nc csv_data/tcolc_eatm
	python3 nc2csv.py ncdf_data/tmax_2m_latlon_subset_19940101_20071231.nc csv_data/tmax_2m
	python3 nc2csv.py ncdf_data/tmin_2m_latlon_subset_19940101_20071231.nc csv_data/tmin_2m
	python3 nc2csv.py ncdf_data/tmp_2m_latlon_subset_19940101_20071231.nc csv_data/tmp_2m
	python3 nc2csv.py ncdf_data/tmp_sfc_latlon_subset_19940101_20071231.nc csv_data/tmp_sfc
	python3 nc2csv.py ncdf_data/ulwrf_sfc_latlon_subset_19940101_20071231.nc csv_data/ulwrf_sfc
	python3 nc2csv.py ncdf_data/ulwrf_tatm_latlon_subset_19940101_20071231.nc csv_data/ulwrf_tatm
	python3 nc2csv.py ncdf_data/uswrf_sfc_latlon_subset_19940101_20071231.nc csv_data/uswrf_sfc
	#

subsets_dir:
	# Create unique directories for each files
	mkdir -p csv_subsets/apcp_sfc
	mkdir -p csv_subsets/dlwrf_sfc
	mkdir -p csv_subsets/dswrf_sfc
	mkdir -p csv_subsets/pres_msl
	mkdir -p csv_subsets/pwat_eatm
	mkdir -p csv_subsets/spfh_2m
	mkdir -p csv_subsets/tcdc_eatm
	mkdir -p csv_subsets/tcolc_eatm
	mkdir -p csv_subsets/tmax_2m
	mkdir -p csv_subsets/tmin_2m
	mkdir -p csv_subsets/tmp_2m
	mkdir -p csv_subsets/tmp_sfc
	mkdir -p csv_subsets/ulwrf_sfc
	mkdir -p csv_subsets/ulwrf_tatm
	mkdir -p csv_subsets/uswrf_sfc

headers:
	mkdir -p csv_subsets
	# Using AWK, output header row in each of the ensemble-specific csv file with new year, month and day columns
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/apcp_sfc/apcp_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/apcp_sfc/apcp_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/dlwrf_sfc/dlwrf_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/dlwrf_sfc/dlwrf_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/dswrf_sfc/dswrf_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/dswrf_sfc/dswrf_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/pres_msl/pres_msl_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/pres_msl/pres_msl-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/pwat_eatm/pwat_eatm_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/pwat_eatm/pwat_eatm-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/spfh_2m/spfh_2m_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/spfh_2m/spfh_2m-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tcdc_eatm/tcdc_eatm_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tcdc_eatm/tcdc_eatm-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tcolc_eatm/tcolc_eatm_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tcolc_eatm/tcolc_eatm-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tmax_2m/tmax_2m_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tmax_2m/tmax_2m-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tmin_2m/tmin_2m_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tmin_2m/tmin_2m-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tmp_2m/tmp_2m_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tmp_2m/tmp_2m-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/tmp_sfc/tmp_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/tmp_sfc/tmp_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/ulwrf_sfc/ulwrf_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/ulwrf_sfc/ulwrf_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/ulwrf_tatm/ulwrf_tatm_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/ulwrf_tatm/ulwrf_tatm-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	#
	number=0 ; while [[ $$number -le 10 ]] ; do \
	  head -n 1 csv_data/uswrf_sfc/uswrf_sfc_latlon_subset_19940101_20071231.csv \
		  | awk 'BEGIN {FS=","; OFS=","} \
		  {print $$1,"year","month","day",$$3,$$4,$$5,$$6,$$7,$$8} ' > csv_subsets/uswrf_sfc/uswrf_sfc-train-$${number}.csv; \
    ((number = number + 1)) ; \
    done;
	

split_data:
	# append relevant data to each of the ensemble-specific csv file
	# Grab the right file, grab only the one day forecast, fill out the new month/day columns and then output the result as a new file
	cat csv_data/apcp_sfc/apcp_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/apcp_sfc/apcp_sfc-train-"$$1".csv"}'
	 #
	cat csv_data/dlwrf_sfc/dlwrf_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/dlwrf_sfc/dlwrf_sfc-train-"$$1".csv"}'
	 #
	cat csv_data/dswrf_sfc/dswrf_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/dswrf_sfc/dswrf_sfc-train-"$$1".csv"}'
	 #
	cat csv_data/pres_msl/pres_msl_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/pres_msl/pres_msl-train-"$$1".csv"}'
	 #
	cat csv_data/pwat_eatm/pwat_eatm_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/pwat_eatm/pwat_eatm-train-"$$1".csv"}'
	 #
	cat csv_data/spfh_2m/spfh_2m_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/spfh_2m/spfh_2m-train-"$$1".csv"}'
	 #
	cat csv_data/tcdc_eatm/tcdc_eatm_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tcdc_eatm/tcdc_eatm-train-"$$1".csv"}'
	 #
	cat csv_data/tmax_2m/tmax_2m_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tmax_2m/tmax_2m-train-"$$1".csv"}'
	 #
	cat csv_data/tmin_2m/tmin_2m_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tmin_2m/tmin_2m-train-"$$1".csv"}'
	 #
	cat csv_data/tmp_2m/tmp_2m_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tmp_2m/tmp_2m-train-"$$1".csv"}'
	 #
	cat csv_data/tmp_sfc/tmp_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tmp_sfc/tmp_sfc-train-"$$1".csv"}'
	 #
	cat csv_data/ulwrf_sfc/ulwrf_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/ulwrf_sfc/ulwrf_sfc-train-"$$1".csv"}'
	 #
	cat csv_data/tcolc_eatm/tcolc_eatm_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/tcolc_eatm/tcolc_eatm-train-"$$1".csv"}'
	 #
	cat csv_data/ulwrf_tatm/ulwrf_tatm_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/ulwrf_tatm/ulwrf_tatm-train-"$$1".csv"}'
	 #
	cat csv_data/uswrf_sfc/uswrf_sfc_latlon_subset_19940101_20071231.csv | \
	grep "1 days 00:00:00" | \
	gawk 'BEGIN {FS=","; OFS=","} \
	{print $$1,substr($$5,1,4),substr($$5,6,2),substr($$5,9,2),$$3,$$4,$$5,$$6,$$7,$$8 \
	 >> "csv_subsets/uswrf_sfc/uswrf_sfc-train-"$$1".csv"}'
	              

combine:
	# Since every meteorological parameter is situated on a different csv file that has the same formatting, this section is used to combine them
	python3 combine.py csv_subsets/apcp_sfc/apcp_sfc-train-0.csv csv_subsets/dlwrf_sfc/dlwrf_sfc-train-0.csv > csv_subsets/combine1.csv
	python3 combine.py csv_subsets/combine1.csv csv_subsets/dswrf_sfc/dswrf_sfc-train-0.csv > csv_subsets/combine2.csv
	python3 combine.py csv_subsets/combine2.csv csv_subsets/pres_msl/pres_msl-train-0.csv > csv_subsets/combine3.csv
	python3 combine.py csv_subsets/combine3.csv csv_subsets/pwat_eatm/pwat_eatm-train-0.csv > csv_subsets/combine4.csv
	python3 combine.py csv_subsets/combine4.csv csv_subsets/spfh_2m/spfh_2m-train-0.csv > csv_subsets/combine5.csv
	python3 combine.py csv_subsets/combine5.csv csv_subsets/tcdc_eatm/tcdc_eatm-train-0.csv > csv_subsets/combine6.csv
	python3 combine.py csv_subsets/combine6.csv csv_subsets/tcolc_eatm/tcolc_eatm-train-0.csv > csv_subsets/combine7.csv
	python3 combine.py csv_subsets/combine7.csv csv_subsets/tmax_2m/tmax_2m-train-0.csv > csv_subsets/combine8.csv
	python3 combine.py csv_subsets/combine8.csv csv_subsets/tmin_2m/tmin_2m-train-0.csv > csv_subsets/combine9.csv
	python3 combine.py csv_subsets/combine9.csv csv_subsets/tmp_2m/tmp_2m-train-0.csv > csv_subsets/combine10.csv
	python3 combine.py csv_subsets/combine10.csv csv_subsets/tmp_sfc/tmp_sfc-train-0.csv > csv_subsets/combine11.csv
	python3 combine.py csv_subsets/combine11.csv csv_subsets/ulwrf_sfc/ulwrf_sfc-train-0.csv > csv_subsets/combine12.csv
	python3 combine.py csv_subsets/combine12.csv csv_subsets/ulwrf_tatm/ulwrf_tatm-train-0.csv > csv_subsets/combine13.csv
	python3 combine.py csv_subsets/combine13.csv csv_subsets/uswrf_sfc/uswrf_sfc-train-0.csv > csv_subsets/gefs-combined.csv
	rm csv_subsets/combine*.csv

linearize_stations:
	mkdir -p train_data
	# create headers and gives each solar energy reading its own row to make it easier to work with
	echo "date,stid,solar_energy" > train_data/train_set_part1.csv
	python3 linearize_stations.py stations/train.csv >> train_data/train_set_part1.csv

add_station_details:
	python3 add_station_details.py stations/complete_station_info.csv train_data/train_set_part1.csv > train_data/train_set_part2.csv
	# add station details (lon, lat and elev) to the training set
add_gefs_data:
	python3 add_gefs_data.py train_data/train_set_part2.csv csv_subsets/gefs-combined.csv > train_data/train_set_part3.csv 
	# add GEFS data to training set
add_historical_data:
	python3 add_historical_data.py train_data/train_set_part3.csv > train_data/train_set_complete1.csv
	# historical averages to training set
random_data_subset:
	# create headers
	head -n 1 train_data/train_set_complete1.csv > train_data/train_set_10000.csv
	# select random samples from data set
	shuf -n 10000 train_data/train_set_complete1.csv >> train_data/train_set_10000.csv
