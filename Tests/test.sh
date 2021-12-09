
# ----- SETUP -----

# Exit if any command fails
set -e

#Go back to main Fuse directory
cd ..

# Build program
make
sudo make install

# Create directories for testing
#mkdir bd_test/
#mkdir mp_test/

# Mount directory
#ntapfuse mount bd_test/ mp_test/

# Enter mountpoint directory
#cd mp_test/

# Set up environment variable for initial tests
export SLEEP_TIME=0

# Notify user
echo
echo
echo " --- Setup successful, starting test suite... ---"
echo 
echo
sleep .5

#########################################################################
### SET-UP ##############################################################
#########################################################################

# Create directories for testing
mkdir bd_test/
mkdir mp_test/

# Mount directory
ntapfuse mount bd_test/ mp_test/ -o allow_other

#Test make sure bd_test was created
if [ -d bd_test/ ];
then
    #echo ""
    #echo "bd_test CREATED"
    :
else
    echo "bd_test CREATION FAILURE"
fi

#Test make sure mp_test was created
if [ -d mp_test/ ];
then
    #echo "mp_test CREATED"
    #echo ""
    :
else
    echo "mp_test CREATION FAILURE"
fi


# Enter mountpoint directory
cd mp_test/

# -------------------- TESTS GO HERE ------------------------

#########################################################################
### TEST 1 - CREATE FILE USING ECHO - NO DATABSE PRESENT ################
#########################################################################

echo ""
echo "########################################################################
### TEST 1 - CREATE FILE USING ECHO - NO db PRESENT ###################
########################################################################"

#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

echo "DISPLAYING db FILE:"
echo ""
cat db
echo ""

numbers_size=$(stat --format=%s "numbers")
echo "DISPLAYING TESTFILE SIZE"
echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 1 SUCCEEDED"
else
    echo "TEST 1 FAILED"
fi

rm db
rm numbers
echo ""


#########################################################################
### TEST 2 - APPENDING TO EXISTING FILE #################################
#########################################################################

echo ""
echo "########################################################################
### TEST 2 - APPENDING TO EXISTING FILE ################################
########################################################################"


#################################################### CREATE FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
#dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
#actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### APPEND TO FILE ######################################################

echo "0987654321" >> numbers

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"
#cat db

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 2 SUCCEEDED"
    :
else
    echo "TEST 2 FAILED"
fi

rm numbers
rm db

echo ""

#########################################################################
### TEST 3 - CREATING TWO DIFFERENT FILES WITH SAME USER ################
#########################################################################


echo "########################################################################
### TEST 3 - CREATING TWO DIFFERENT FILES WITH SAME USER ###############
########################################################################"


#################################################### CREATE 1ST FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### CREATE 2ND FILE ######################################################

#echo "1:    Creating numbers file"
echo "ABCDEFGHIJKLMNOPQRSTUVWXYZ" > letters

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

letters_size=$(stat --format=%s "letters")
#echo "DISPLAYING TESTFILE SIZE"
#echo $letters_size

letters_user=$(stat -c '%u' "letters")
#echo $numbers_user

if [[ "$letters_user" == "$numbers_user" ]] 
then
    #echo "TEST 1 SUCCEEDED"
    :
else
    echo "LETTERS AND NUMBERS USERS ARE NOT EQUAL"
fi

updated_size=$(($letters_size + $numbers_size))

test_str="${letters_user} ${updated_size} 5000"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 3 SUCCEEDED"
    :
else
    echo "TEST 3 FAILED"
fi

rm numbers
rm letters 
rm db

echo ""

#########################################################################
### TEST 4 - REMOVING THE ONLY FILE  ####################################
#########################################################################

echo ""
echo "########################################################################
### TEST 4 - REMOVING THE ONLY FILE ####################################
########################################################################"


#################################################### CREATE FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### REMOVE FILE ######################################################

rm numbers

numbers_test_str="${numbers_user} 0 5000"
dbfile="$(cat db)"

#echo "$numbers_test_str"
#echo "$dbfile"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 4 SUCCEEDED"
    :
else
    echo "TEST 4 FAILED"
fi

rm db

echo ""


#########################################################################
### TEST 5 - CREATING MULTIPLE FILES AND REMOVING ONE ###################
#########################################################################

echo ""
echo "########################################################################
### TEST 5 - CREATING MULTIPLE FILES AND REMOVING ONE ##################
########################################################################"


#################################################### CREATE 1ST FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

#echo "$numbers_test_str"
#echo "$dbfile"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### CREATE 2ND FILE ######################################################

#echo "1:    Creating numbers file"
echo "ABCDEFGHIJKLMNOPQRSTUVWXYZ" > letters

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

letters_size=$(stat --format=%s "letters")
#echo "DISPLAYING TESTFILE SIZE"
#echo $letters_size

letters_user=$(stat -c '%u' "letters")
#echo $numbers_user

if [[ "$letters_user" == "$numbers_user" ]] 
then
    #echo "TEST 1 SUCCEEDED"
    :
else
    echo "LETTERS AND NUMBERS USERS ARE NOT EQUAL"
fi

updated_size=$(($letters_size + $numbers_size))

test_str="${letters_user} ${updated_size} 5000"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "db FILE NOT UPDATED FOR SECOND FILE CREATION"
fi

#################################################### REMOVE 1ST FILE ######################################################

rm numbers

updated_size=$(($updated_size - $numbers_size))

test_str="${letters_user} ${updated_size} 5000"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 5 SUCCEEDED"
    :
else
    echo "TEST 5 FAILED"
fi

rm letters 
rm db

echo ""

#########################################################################
### TEST 6 - CREATING MULTIPLE FILES WITH DIFFERENT USERS ###############
#########################################################################

echo ""
echo "########################################################################
### TEST 6 - CREATING MULTIPLE FILES WITH DIFFERENT USERS ##############
########################################################################"

#################################################### CREATE FIRST FILE WITH ROOT ######################################################

#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    #echo "TEST 6 SUCCEEDED"
    :
else
    echo "TEST 6 FAILED"
    :
fi

#################################################### CREATE ANOTHER USER  ######################################################

#Create the user to be used in the test
sudo useradd -m -p Password -G sudo testuser

#Traverse back to the testscripts file
cd ..
cd Tests

#################################################### CREATE SECOND FILE ######################################################

#Make the script to be executed by the testuser executable
chmod +x test6_testuser.sh

#Make testuser execute script for this test.
sudo -u testuser ./test6_testuser.sh

#Traverse back to the mountpoint
cd ..
cd mp_test

#cd aiphngbspio

#################################################### TEST THE OTHER FILE ######################################################

#Get the expected size of the testuser's file
hello_testuser_size=$(stat --format=%s "hello_testuser")

#Get the user of the testuser's file
hello_testuser_user=$(stat -c '%u' "hello_testuser")

test6_str="${numbers_test_str} ${hello_testuser_user} ${hello_testuser_size} 5000"
echo $test6_str

rm db
rm numbers
echo ""



echo ""

#########################################################################
### TEST 7? - CREATING MULTIPLE FILES WITH DIFFERENT USERS ###############
#########################################################################

echo ""
#################################################### UNLINK TEST ######################################################
#echo "1:    Creating new empty file"
echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified size, now verify not being as large

rm newFile

#numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

#numbers_user=$(stat -c '%u' "1000")
#echo $numbers_user

numbers_test_str="$numbers_user 0 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 7? PASSED"
    :
else
    echo "FILE RM DID NOT DECREMENT"
    cat db
fi

rm db

echo "
#########################################################################
### TEST 8? - RENAME					    ###############
#########################################################################
"

echo ""
#echo "1:    Creating new empty file"

echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified size, now change name

mv newFile numbers

if [ -a numbers ];
then
	if [ ! -a newFile ];
	then
		echo "TEST 8? PASSED"
		:
	else 
		echo "TEST 8? FAILED"
	fi
else
	echo "TEST 8? FAILED"
fi
		

rm numbers
rm db


echo "
#########################################################################
### TEST 8? - CHANGING OWNERSHIP			    ###############
#########################################################################
"

echo ""
#echo "1:    Creating new empty file"

echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified old owner, now change owner

chown 1000 newFile

numbers_user=$(stat -c '%u' "newFile")

numbers_test_str="
0 0 5000
1000 ${numbers_size} 5000
"
dbfile="$(cat db)"
cat db
echo ${numbers_test_str}

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "CHOWN TEST PASSED"
else
    echo "CHOWN TEST FAILED"
fi
		

rm newFile
rm db



# ------------------- CONCURRENCY TESTS------------------------

cd ..

# Close program, must be restarted to update environment var
sudo umount mp_test/

# Set up environment variable for initial tests
export SLEEP_TIME=1

ntapfuse mount bd_test/ mp_test/ -o allow_other

repo_root=$(pwd)

cd mp_test/


#########################################################################
### TEST C1 - CREATE FILE USING ECHO - NO DATABSE PRESENT ################
#########################################################################

echo ""
echo "----- BEGINNING CONCURRENCY TESTS, THESE ARE SLOWER DUE TO ADDED DELAY -----"
echo ""

echo ""
echo "########################################################################
### TEST C1 - ONE USER WRITING TO TWO DIFFERENT FILES AT SAME TIME #####
########################################################################"

#echo "1:    Creating numbers file"

# Run first concurrency test
python3 ${repo_root}/Tests/c1.py



file1_expected="123456789"
file1="$(cat file1)"
file2_expected="987654321"
file2="$(cat file2)"

db_expected="1000 20 5000"
db=$(cat db)

# Check db
expected=$(echo $db_expected)
actual=$(echo $db)
if [[ "$expected" == "$actual" ]] 
then
    echo "DB PASS"
else
    echo $expected
    echo $actual
fi

# Check file 1
expected=$(echo $file1_expected)
actual=$(echo $file1)
if [[ "$expected" == "$actual" ]] 
then
    echo "F1 PASS"
else
    echo "FAIL"
fi

# Check file 2
expected=$(echo $file2_expected)
actual=$(echo $file2)
if [[ "$expected" == "$actual" ]] 
then
    echo "F2 PASS"
else
    echo "FAIL"
fi


rm file1
rm file2

# ------------------- TESTS END HERE ------------------------


# ----- CLEANUP -----

# Notify user
echo
echo
echo " --- Cleaning up... ---"
echo 
echo
sleep .5

# Exit mountpoint directory
cd ..

# Unmount directory
sudo umount mp_test/

# Remove test directories
rm -rf bd_test/
rm -rf mp_test/

# Set up environment variable for initial tests
export SLEEP_TIME=0

# Remove testusers
sudo pkill -KILL -u testuser
sudo userdel -r testuser
