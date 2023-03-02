CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
mkdir student-submission
git clone $1 student-submission
echo 'Finished cloning'

cp TestListExamples.java student-submission
cd student-submission
if [[ -f ListExamples.java ]]
then 
    echo "ListExamples.java found"
else 
    echo "need file ListExamples.java"
    exit 1
fi

javac -cp $CPATH *.java 
if [[ $? -eq 0 ]];
then 
    echo "ListExamples.java successfully compiled"
else 
    echo "ListExamples.java did not compile correctly"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > score.txt

grep -C 0 "Tests run:" score.txt > grep-score.txt
if [[ -s grep-score.txt ]]
then
    grep -o "[0-9]*" grep-score.txt > numbers.txt
    TESTS=`head -n 1 numbers.txt`
    FAILS=`tail -n 1 numbers.txt`
    DIFFERENCE=`expr $TESTS - $FAILS`
    GRADE=`expr $DIFFERENCE / $TESTS \* 100`
    echo "You failed $FAILS out of $TESTS tests"
    echo "Your grade is $GRADE%"
else 
    echo "You failed 0 tests"
    echo "Your grade is 100%!"
fi