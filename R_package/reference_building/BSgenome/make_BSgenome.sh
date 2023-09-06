# this script is for making BSgenome and install in R
# author: laojp
# time: 2023.09.06
# position: SYSUCC bioinformatic platform
# usage: 
#  make_BSgenome.sh [seed_file] [fa_file] [output_dir]
#   [fa]: all_fa uncompressed .fa file
#  place all file in the same dir
#  the fa_file can not in the same dir with output_dir

script_dir=$(readlink -f "$0" | xargs dirname)

echo "---------- first split of the reference fa ----------"
perl ${script_dir}/split_reference.pl ${2} ${3}

echo "---------- second make the twobit file for all fa file ----------"
if [ $(command -v mamba) ]; then
	echo "mamba is installed"
else
	conda install -c bioconda -c conda-forge mamba --yes # install the software with mamba 
fi
if [ $(command -v faToTwoBit) ]; then
	echo "faToTwoBit is installed"
else
	mamba install -c bioconda -c conda-forge ucsc-fatotwobit --yes # install the software with mamba 
fi

# scan fa in inputdir and convert to twobit
find ${3} -name "*.fa" | while read id ; do
	echo "${id} started"
	faToTwoBit $(realpath ${id}) ${3}/$(basename ${id} .fa).2bit &
done




